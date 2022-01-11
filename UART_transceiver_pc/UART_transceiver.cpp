#include <windows.h>
#include <stdio.h>
#include <iostream>

#pragma warning(disable:4996)

#define PROPAGATION_TIME 7

LPCWSTR port = L"\\\\.\\COM10";

int main()
{
	FILE* output = fopen("filters_output.txt", "w");

	// Declare variables and structures
	HANDLE hSerial;
	DCB dcbSerialParams = { 0 };
	COMMTIMEOUTS timeouts = { 0 };

	std::cout << "################################\n";
	std::cout << "##   DIGITAL SIGNAL FILTERS   ##\n";
	std::cout << "################################\n\n";

	std::cout << "Instructions:\n\n";

	std::cout << "\tSelect one of the following switches from the board:\n";
	std::cout << "\t\t 00 -> 2*xn + 3*xn1\n";
	std::cout << "\t\t 01 -> xn + 2*n*xn1\n";
	std::cout << "\t\t 10 -> 4*xn + 2*xn1 + 3*xn2\n";
	std::cout << "\t\t 11 -> xn*xn + xn1*xn1\n\n";

	std::cout << "\tAfter every input, press enter and then press the central button on board.\n";
	std::cout << "\tEvery 5 inputs, you will be asked if you want to end.\n";
	std::cout << "\tFor terminating the program, input 'N' when asked.\n";
	std::cout << "\tAfter the command for termination, keep pressing enter and the central button\n";
	std::cout << "\ton the board for result propagation until the program is finished.\n\n";

	// Open the highest available serial port number
	std::cout << "Opening serial port...\n";
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

	char answer = 0;

	std::cout << "Start sending numbers? (Y/N): \n";
	scanf("%c", &answer);

	if (answer == 'Y') {

		char c = 0;
		int index = 0;
		bool finish = false;

		int number_to_send = 0;
		std::cout << "Your input: ";
		scanf("%d", &number_to_send);

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

		while (!finish) {

			answer = 0;

			if (index % 5 == 0) {
				std::cout << "Keep sending numbers? (Y/N): ";
				scanf(" %c", &answer);
			}

			if (answer == 'N') finish = true;
			else
			{
				//reading serial port
				char byte_to_receive = 0;

				if (!ReadFile(hSerial, &byte_to_receive, 1, &bytes_read, NULL)) {
					std::cout << "Reading from port failed. Error: %d.\n", GetLastError();
					CloseHandle(hSerial);
					return (4);
				}
				else {
					if (index > PROPAGATION_TIME) { 
						fprintf(output, "%d\n", (int)byte_to_receive);
					}
				}

				//writing to serial port
				number_to_send = 0;
				std::cout << "Your input: ";
				scanf("%d", &number_to_send);
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
		std::cout << "Finished writing all the numbers to serial port.\n";
	}

	// Close serial port
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