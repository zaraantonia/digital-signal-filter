#include <windows.h>
#include <stdio.h>
#include <iostream>

#pragma warning(disable:4996)

#define PROPAGATION_TIME 7

LPCWSTR port = L"\\\\.\\COM10";

int main()
{
    FILE* output = fopen("filters_output.txt", "w");

    // Define the five bytes to send ("hello")
    char bytes_to_send[5];
    bytes_to_send[0] = 1;
    bytes_to_send[1] = 2;
    bytes_to_send[2] = 3;
    bytes_to_send[3] = 4;
    bytes_to_send[4] = 5;

    // Declare variables and structures
    HANDLE hSerial;
    DCB dcbSerialParams = { 0 };
    COMMTIMEOUTS timeouts = { 0 };

    // Open the highest available serial port number
    std::cout << "Opening serial port...";
    hSerial = CreateFile(
        port, GENERIC_READ | GENERIC_WRITE, 0, NULL,
        OPEN_EXISTING, FILE_ATTRIBUTE_NORMAL, NULL);
    if (hSerial == INVALID_HANDLE_VALUE)
    {
        std::cout << "Error opening serial port\n";
        return 1;
    }
    else std::cout << "Serial port opened OK\n";

    // Set device parameters (38400 baud, 1 start bit,
    // 1 stop bit, no parity)
    dcbSerialParams.DCBlength = sizeof(dcbSerialParams);
    if (GetCommState(hSerial, &dcbSerialParams) == 0)
    {
        fprintf(stderr, "Error getting device state\n");
        CloseHandle(hSerial);
        return 1;
    }

    dcbSerialParams.BaudRate = CBR_115200;
    dcbSerialParams.ByteSize = 8;
    dcbSerialParams.StopBits = ONESTOPBIT;
    dcbSerialParams.Parity = NOPARITY;

    if (SetCommState(hSerial, &dcbSerialParams) == 0)
    {
        std::cout << "Error setting device parameters\n";
        CloseHandle(hSerial);
        return 1;
    }

    // Set COM port timeout settings
    timeouts.ReadIntervalTimeout = 50;
    timeouts.ReadTotalTimeoutConstant = 50;
    timeouts.ReadTotalTimeoutMultiplier = 10;
    timeouts.WriteTotalTimeoutConstant = 50;
    timeouts.WriteTotalTimeoutMultiplier = 10;
    if (SetCommTimeouts(hSerial, &timeouts) == 0)
    {
        std::cout << "Error setting timeouts\n";
        CloseHandle(hSerial);
        return 1;
    }

    // Send numbers
    DWORD bytes_written, total_bytes_written = 0;
    DWORD bytes_read, total_bytes_read = 0;

    std::cout << "Start sending numbers...\n";

    char c = 0;
    int index = 1;

    int number_to_send = 1;

    //writing to serial port
    if (!WriteFile(hSerial, &number_to_send, 1, &bytes_written, NULL))
    {
        std::cout << "Error sending number " << (int)number_to_send << "\n";
        CloseHandle(hSerial);
        return 1;
    }
    else {
        std::cout << "Written " << (int)number_to_send << " to serial port\n";
        index++;
    }

    while(c != 'q'){
       
        c = getchar();

        if (c == 10) {
            number_to_send++;

            //reading serial port
            char byte_to_receive = 0;

            if (!ReadFile(hSerial, &byte_to_receive, 1, &bytes_read, NULL)) {
                std::cout << "Reading from port failed. Error: %d.\n", GetLastError();
                CloseHandle(hSerial);
                return (4);
            }
            else {
                //std::cout << "Read output " << (int)byte_to_receive << "\n";

                if (index > PROPAGATION_TIME) { //i have no idea why 3 but work with it
                    fprintf(output, "%d\n", (int)byte_to_receive);
                }
            }

            //writing to serial port
            if (!WriteFile(hSerial, &number_to_send, 1, &bytes_written, NULL))
            {
                std::cout << "Error sending number " << (int)number_to_send << "\n";
                CloseHandle(hSerial);
                return 1;
            }
            else {
                std::cout << "Written " << (int)number_to_send << " to serial port\n";
                index++;
            }
        }

    }

    number_to_send = 0;

    for (int i = 0; i <= PROPAGATION_TIME; i++) {

        //reading serial port
        char byte_to_receive = 0;
        if (!ReadFile(hSerial, &byte_to_receive, 1, &bytes_read, NULL)) {
            std::cout << "Reading from port failed. Error: %d.\n", GetLastError();
            CloseHandle(hSerial);
            return (4);
        }
        else {
            //std::cout << "Read output " << (int)byte_to_receive << "\n";
            if (index > PROPAGATION_TIME) { //i have no idea why 3 but work with it
                fprintf(output, "%d\n", (int)byte_to_receive);
            }
        }

        do {
            c = getchar();
        } while (c != 10);

        //writing to serial port

        if (!WriteFile(hSerial, &number_to_send, 1, &bytes_written, NULL))
        {
            std::cout << "Error sending number " << (int)number_to_send << "\n";
            CloseHandle(hSerial);
            return 1;
        }
        else {
            std::cout << "Padding to serial port. Keep pressing enter.\n";
            index++;
        }
    }

    // Close serial port
    std::cout << "Finished writing all the numbers to serial port.\n";
    std::cout << "Closing serial port...\n";
    if (CloseHandle(hSerial) == 0)
    {
        std::cout << "Error closing serial port.\n";
        return 1;
    }
    std::cout << "Serial port is closed. :) \n";

    fclose(output);

    // exit normally
    return 0;
}