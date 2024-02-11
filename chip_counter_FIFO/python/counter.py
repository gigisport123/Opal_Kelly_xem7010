# Name: Yu-Chi Lin
# Date: Feb. 2, 2024
# Description:  Sp23 sensor ADC counter output
#               DUT <--> Opal Kelly <--> PC
#               python interface between Opal Kelly and PC

import ok
import sys

file_path = "C:/Users/gigis/opal_kelly_code/chip_counter_FIFO/chip_counter_FIFO.runs/impl_1/decode.bit"


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
    def get_counter_data(self, outfile):
        fileOut = open(outfile, "wb")
        # set wire in (addr, data, mask)
        # set reset to be high
        self.xem.SetWireInValue(0x00, 0x1, 0x1)
        self.xem.UpdateWireIns()
        self.xem.SetWireInValue(0x00, 0x0, 0x1)
        self.xem.UpdateWireIns()
        
        # wait for the TriggerOut indicating data stored finish
        for i in range(100):
            self.xem.UpdateTriggerOuts()
            if (self.xem.IsTriggered(0x60, 1)):
                break
        buf = bytearray(b'\x01') * 10 ** 3
        self.xem.ReadFromPipeOut(0xa0, buf)
        fileOut.write(buf)
        print(buf[0])
        print(buf[1])
        print(buf[2])

print("decoding counter mux from DUT")

counter = Counter()
if not counter.InitializeDevice():
    exit(-1)

counter.get_counter_data('test.out')


        