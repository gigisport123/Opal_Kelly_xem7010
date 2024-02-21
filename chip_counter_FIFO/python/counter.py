# Name: Yu-Chi Lin
# Date: Feb. 2, 2024
# Description:  Sp23 sensor ADC counter output
#               DUT <--> Opal Kelly <--> PC
#               python interface between Opal Kelly and PC

import ok
import sys

file_path = "C:/Users/gigis/opal_kelly_code/chip_counter_FIFO/chip_counter_FIFO.runs/impl_1/TOP.bit"
'''bit file generated from sample first; use to confirm that FrontPanel support is available.''' 
# file_path = "C:/Users/gigis/FPGA_code/sample_first/sample_first.runs/impl_1/First.bit"    
# M = 300        # number of pipeout data; each is 16 bits
# N = 800        # number of counter samples; each is 6 bits

# size of FIFO = 48 * 64
FIFO_depth = 64 
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
    def get_counter_data(self, buf, outfile):
        fileOut = open(outfile, "wb")
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
        fileOut.write(buf)
        fileOut.close()

    # flip the odd and even index of byte; not sure why it flips
    def flip_counter_data(self, data, outfile):
        fileOut = open(outfile, "wb")
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
        fileOut.write(data)
        fileOut.close()


    # decode data from pipeout byte into 6 bit counter output
    def decode_counter_data(self, data, outfile):
        fileOut = open(outfile, "w")
        data_6bitp = []
        data_6bitn = []
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
 
        fileOut.write(str(data_6bitn))
        fileOut.write(str('\n'))
        fileOut.write(str(data_6bitp))
        fileOut.close()


print("decoding counter mux from DUT")

counter = Counter()
if not counter.InitializeDevice():
    exit(-1)


counter.get_counter_data(dataout, 'test.out')
counter.flip_counter_data(dataout, 'flip.txt')
counter.decode_counter_data(dataout, 'counter_out_test.txt')


        