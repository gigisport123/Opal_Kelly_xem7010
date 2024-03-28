# Name: Yu-Chi Lin
# Date: Feb. 2, 2024
# Description:  Sp23 sensor ADC counter output
#               DUT <--> Opal Kelly <--> PC
#               python interface between Opal Kelly and PC

import ok
import sys
import matplotlib.pyplot as plt
import numpy as np
import datetime
import os

# measurement details
IDAC = 8
vinp = 0
vinn = 0
fs = 12 * 10**6  # sampling clk 
sw = 1
filename_str = 'rawdata_IDAC'+str(IDAC)+'_fs'+str(fs/10**6)+'_sw'+str(sw)+'_vinp'+str(vinp)+'_vinn'+str(vinn)

# time stamp for dumped files
time_now  = datetime.datetime.now().strftime('%m_%d_%Y_%H_%M_%S') 
# file_path = "C:/Users/gigis/opal_kelly_code/chip_counter_FIFO/python/TOP_12MHz_32678.bit"
file_path = "C:/Users/gigis/opal_kelly_code/chip_counter_FIFO/chip_counter_FIFO.runs/impl_1/TOP.bit"
'''bit file generated from sample first; use to confirm that FrontPanel support is available.''' 
# file_path = "C:/Users/gigis/FPGA_code/sample_first/sample_first.runs/impl_1/First.bit"    
# M = 300        # number of pipeout data; each is 16 bits
# N = 800        # number of counter samples; each is 6 bits

# size of FIFO = 48 * 32768
FIFO_depth = 2**15 
# FIFO_depth = 64
FIFO_width = 48 
byte_num = int(FIFO_depth * FIFO_width / 8)  
dataout = bytearray(b'\x01') * byte_num


class Counter:
    def _init_(self):
        return
    
    def InitializeDevice(self):
        # Open the first device we find.
        self.xem = ok.FrontPanelDevices().Open()
        if not self.xem:
            print("Device could not be opened. Connected?")
            return(False)
        
        # Get some general information about the device.
        self.devInfo = ok.okTDeviceInfo()
        if (self.xem.NoError != self.xem.GetDeviceInfo(self.devInfo)):
            print ("Unable to retrieve device information.")
            return(False)
        print("         Product: " + self.devInfo.productName)
        print("Firmware version: %d.%d" % (self.devInfo.deviceMajorVersion, self.devInfo.deviceMinorVersion))
        print("   Serial Number: %s" % self.devInfo.serialNumber)
        print("       Device ID: %s" % self.devInfo.deviceID)
        
        self.xem.LoadDefaultPLLConfiguration()

        # Download the configuration file.
        if (self.xem.NoError != self.xem.ConfigureFPGA(file_path)):
            print ("FPGA configuration failed.")
            return(False)

        # Check for FrontPanel support in the FPGA configuration.
        if (False == self.xem.IsFrontPanelEnabled()):
            print ("FrontPanel support is not available.")
            return(False)
        
        print ("FrontPanel support is available.")
        return(True)
    
    # Retrieve value on Wire endpoint with address 0x20, 0x21, 0x22
    def get_counter_data(self, buf, outfile, raw=False):
        # set wire in (addr, data, mask)
        # set reset to be high
        self.xem.SetWireInValue(0x00, 0x1, 0x1)
        self.xem.UpdateWireIns()
        self.xem.SetWireInValue(0x00, 0x0, 0x1)
        self.xem.UpdateWireIns()
        
        # wait for the TriggerOut indicating data stored finish
        for i in range(10000):
            self.xem.UpdateTriggerOuts()
            if (self.xem.IsTriggered(0x60, 1)):
                break
  
        self.xem.ReadFromPipeOut(0xa0, buf)
        
        if raw:
            fileOut = open(outfile, "wb")
            fileOut.write(buf)
            fileOut.close()

    # flip the odd and even index of byte; not sure why it flips
    def flip_counter_data(self, data, outfile, raw=False):
        data_swap = []
        i = 0
        while i < byte_num:
            swap = data[i]
            data[i] = data[i+1]
            data[i+1] = swap
            data_swap.append(data[i])
            data_swap.append(data[i+1])
            i = i + 2
        # fileOut.write(str(data_swap))
        if raw:
            fileOut = open(outfile, "wb")
            fileOut.write(data)
            fileOut.close()


    # decode data from pipeout byte into 6 bit counter output
    # raw: output raw data file 
    # graph: output a plot of raw data
    def decode_counter_data(self, data, data_6bitp, data_6bitn, outfile, raw=False, graph=False):
        # data_6bitp = []
        # data_6bitn = []
        # start decoding data from data[10]; 0~9 are extra datas of 0s
        # probably from bad verilog coding. can probably be fixed from FSM
        i = 10      
        while i+3 < byte_num:
        # while i < 1:
            data1 = data[i] >> 2
            data2 = ((data[i] & 0x3) << 4) | (data[i+1] >> 4)
            data3 = ((data[i+1] & 0xf) << 2) | (data[i+2] >> 6)
            data4 = data[i+2] & 0x3f
            data_6bitp.append(data1)
            data_6bitp.append(data3)
            data_6bitn.append(data2)
            data_6bitn.append(data4)
            # print(data1)
            # print(data2)
            # print(data3)
            # print(data4)
            i = i + 3
 
        if raw:
            fileOut = open(outfile, "w")
            fileOut.write(str(data_6bitn))
            fileOut.write(str('\n'))
            fileOut.write(str(data_6bitp))
            fileOut.close()

        if graph:
            figure, axis = plt.subplots(1, 2) 
  
            # t = range(1,100) * 1.0 / fs

            # For n side
            axis[0].plot(data_6bitn[0:100]) 
            axis[0].set_title("n") 
            axis[0].set_xlabel('sample #')
            axis[0].set_ylabel('counter value')
            
            # For p side 
            axis[1].plot(data_6bitp[0:100]) 
            axis[1].set_title("p") 
            axis[1].set_xlabel('sample #')
            # axis[1].set_ylabel('counter value')


            # plt.plot(data_6bitn, color='b', label='n')
            # plt.plot(data_6bitp, color='g', label='p')
            # plt.legend()
            # plt.show()
            plt.savefig("counter_out_"+str(time_now)+".png")

    def counter_to_freq(self, data_6bitp, data_6bitn, outfile, trial, graph=False):
        fileOut = open(outfile, "w")
        freq_n = []
        freq_p = []

        # file format: sample, n, diff_n, p, diff_p
        # fileOut.write(str('freq_n\n'))
        fileOut.write('sample\tn\tdiff_n\tp\tdiff_p\n')
        # initialize first line (no difference yet)
        fileOut.write('0'+'\t'+str(data_6bitn[0])+'\t'+'\t')
        fileOut.write(str(data_6bitp[0])+'\t'+'\t'+'\n')
        i = 1
        while i < len(data_6bitn):
            # n side
            cnt_interval = data_6bitn[i] - data_6bitn[i-1]
            if (cnt_interval < 0):
                cnt_interval  = cnt_interval + 64
            # period = Ts * 1.0 / cnt_interval
            freq = fs * cnt_interval
            fileOut.write(str(i)+'\t'+str(data_6bitn[i])+'\t'+str(cnt_interval)+'\t')
            freq_n.append(freq)
           
            # p side
            cnt_interval = data_6bitp[i] - data_6bitp[i-1]
            if (cnt_interval < 0):
                cnt_interval  = cnt_interval + 64
            freq = fs * cnt_interval
            freq_p.append(freq)
            fileOut.write(str(data_6bitp[i])+'\t'+str(cnt_interval)+'\n')
            i = i + 1
        
        # fileOut.write(str('freq_p\n'))
        # i = 1
        # while i < len(data_6bitp):
        #     cnt_interval = data_6bitp[i] - data_6bitp[i-1]
        #     if (cnt_interval < 0):
        #         cnt_interval  = cnt_interval + 64
        #     freq = fs * cnt_interval
        #     freq_p.append(freq)
        #     fileOut.write(str(i)+'\t'+str(data_6bitp[i])+'\t'+str(data_6bitp[i-1])+'\t'+str(cnt_interval))
        #     fileOut.write(str('\n'))
        #     i = i + 1
        
        # fileOut.write(str(freq_p))
        # fileOut.write(str('\n'))
        # fileOut.write(str(freq_n))
        avg_p = sum(freq_p) / len(freq_p)
        avg_n = sum(freq_n) / len(freq_n)
        fileOut.write('freq_P_avg\t'+str(avg_p)+'\n')
        fileOut.write('freq_N_avg\t'+str(avg_n)+'\n')
        fileOut.close()
        
        if graph:
            figure, axis = plt.subplots(1, 2) 
        
            t = np.arange(0,len(freq_n)) * 1.0 / fs

            # For n side
            axis[0].plot(t[1:255], freq_n[1:255]) 
            axis[0].set_title("n") 
            axis[0].set_xlabel('time (s)')
            axis[0].set_ylabel('osc freq (Hz)')
            
            # For p side 
            axis[1].plot(t[1:255], freq_p[1:255]) 
            axis[1].set_title("p") 
            axis[1].set_xlabel('time (s)')
            # axis[1].set_ylabel('freq(Hz)')

            # plt.show()
            plt.savefig('./'+filename_str+'./'+"freq_"+str(time_now)+str(trial)+".png")


print("decoding counter mux from DUT")

counter = Counter()
if not counter.InitializeDevice():
    exit(-1)

if not os.path.isdir('./'+filename_str):
    os.makedirs('./'+filename_str)

for trial in range(1):
    counter.get_counter_data(dataout, './'+filename_str+'./'+"test_"+str(time_now)+".out", raw=True)
    counter.flip_counter_data(dataout, './'+filename_str+'./'+"flip_"+str(time_now)+".txt", raw=True)

    data_6bitp = []
    data_6bitn = []
    counter.decode_counter_data(dataout, data_6bitp, data_6bitn, './'+filename_str+"counter_out_test_"+str(time_now)+".txt")
    # print(data_6bitn)
    # print(data_6bitp)
    counter.counter_to_freq(data_6bitp, data_6bitn, './'+filename_str+'./'+filename_str+'_trial_'+str(trial)+".txt", trial=str(trial), graph=True)

        