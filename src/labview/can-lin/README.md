# CAN/LIN Raw Bus Capture Measurement Plugin for Instrument Studio in LabVIEW

This plugin is an easy-to-use CAN/LIN Bus capture with sorting and filtering option. It uses the Measurement Plugin SDK.

## Contents

1. The service logic main file is the **CAN-LIN Raw Bus Capture\Measurement Logic.vi**.
2. The UI part is implemented in the  **CAN-LIN Raw Bus Capture UI\Measurement UI.vi** file.

The UI uses the **Tables and Filtering** library for sorting and filtering, and an OOB (Out-of-Band) gRPC client loop to receive measurement data from the service.

## Prerequisites

- **LabVIEW 2025 Q3**
- **Measurement Plugin SDK 3.5.0.2**
- **Instrument Studio 2025 Q4**.
- **NI PXIe-8510** with NI-XNET-CAN and/or NI-XNET-LIN transceiver

## How to run this plugin

Open the `CAN-LIN Raw Bus Capture.lvproj` project in **LabVIEW 2025**.
![image](<img/00.png>)

Build the **CAN-LIN Raw Bus Capture UI**.

![image](<img/01.png>)

Open **Run Service.vi** from the **CAN-LIN Raw Bus Capture** class

![image](<img/02.png>)
![image](<img/03.png>)

Run the VI

![image](<img/04.png>)

Open **Instrument Studio 2025** and create **Manual Layout**

![image](<img/05.png>)

Select **CAN-LIN Raw Bus Capture** as a large Panel

![image](<img/06.png>)

The plugin UI in Instrument Studio is shown below.

When a DBC file is loaded, the Trace Window displays raw data in a root/child tree, with decoded frame, signal, and value information. The Signal Table displays DBC-decoded signal information in the ID, Frame, Signal, Value, and Rate columns.

![image](<img/07.png>)

## How to configure the plugin

Select the bus type

![image](<img/08.png>)

### CAN configuration

![image](<img/09.png>)

1. Select the CAN interface
2. Select Run Mode:
    - Normal (standard operating mode; the CAN settings below apply in this mode)
    - Subordinate (the interface operates under the control of a master device)
3. Select the IO Mode:
    - CAN (Standard Controller Area Network)
    - CAN FD (Flexible Data-Rate)
    - CAN FD+BRS (Flexible Data-Rate and Bit Rate Switch)
4. Set baudrate (hexadecimal value)
    - 1E848 for 125 kbps
5. Set FD ISO Mode (optional when IO Mode is set to CAN FD or CAN FD+BRS)
    - ISO
    - Non ISO
    - Legacy ISO
6. Set FD baudrate (hexadecimal value) (optional when IO Mode is set to CAN FD or CAN FD+BRS)
    - F4240 for 1 mbps
7. Turn on the termination resistor if it is needed for the bus.
8. Select the DBC file to decode CAN messages into frame and signal names and values.

### LIN configuration

![image](<img/10.png>)

1. Select the LIN(Local Interconnect Network) interface
2. Turn on the termination resistor if it is needed for the bus.

*Note: The plugin connects to the LIN bus as a slave node with 128 kpbs baudrate.

## How to deploy the plugin (local only)

Build the **CAN-LIN Raw Bus Capture** and the **CAN-LIN Raw Bus Capture UI**

![image](<img/20.png>)

Copy the `src\labview\builds\CAN-LIN Raw Bus Capture\CAN-LIN Raw Bus Capture` folder under the `C:\ProgramData\National Instruments\Plug-Ins\Measurements` location.

![image](<img/21.png>)

## How to start and use the plugin

Start the plugin with the **RUN** button in the Instrument Studio.

![image](<img/11.png>)

It connects to the selected bus and starts listening. The service updates the UI every 150ms for CAN, and 100ms for LIN. The connection LED turns on.
The Trace Window displays raw bus data and, when a DBC file is loaded, the decoded frame, signal, and value information in a tree. The Signal Table displays the ID, frame, signal, value, and rate without the raw data. The Status area displays the current bus status. The DBC Information section shows whether the DBC file is valid and the number of frames and signals it contains.

![image](<img/12.png>)

The user can interact with the plugin by the control area such as sorting, filtering, pause / resume and clear the trace table or save log files in TDMS or CSV format.

![image](<img/13.png>)

### Sorting
The default order of the messages is by timestamp, it can change by the **Sort by ID** checkbox.

![image](<img/14.png>)

### Filter
Use the headers of the trace table to set conditions what to filter.

In the Trace Window, if a root row matches the filter, all of its children are shown. If a child field (Frame, Signal, or Value) matches, its root row and only the matching child rows are shown. In the Signal Table, only signal rows that match the filter are displayed.

The Value and Rate columns may include units, such as V, km/h, or Hz. When filtering these columns, enter only the value and omit the unit (for example, `Rate < 99`).

Filter expressions use sets of three arguments in the format **Field, Operator, Value**, separated by logical operators. Use spaces to separate keywords, quotation marks for strings containing spaces, and the `0x` prefix for hexadecimal values.

**Examples:**

    Value < 11 OR ID == 0x720

    Type == "CAN Data"

    ID == 0xAA

![image](<img/15.png>)

![image](<img/16.png>)

![image](<img/17.png>)

### Save trace to log file (TDMS, CSV)

The user can set a path in the control area and save the trace data to CSV or TDMS file with the **SAVE** button. The file name auto generated as {BusType_tracelog_YYYYMMDD_HHIISSTUUU}
The saved file contains the most recent 10,000 raw data rows retained in the background. A response message appears at the bottom of the Status area.

### Pause / Resume capture

Use this button to pause the trace table updates. Messages received while paused are not queued for later display and are lost. After you resume, only newly received messages appear in the tree.

### Auto Scrolling

Auto-scrolling is available in the Signal Table, but not in the Trace Window tree. In the tree, new data appears at the bottom. If a row with the same ID already exists, it is updated instead of adding a new row.

When the Signal Table is not paused, it automatically scrolls to the latest packet. You can disable auto-scroll by moving the scrollbar up. To re-enable it, scroll to the bottom of the Signal Table. Messages received while paused are lost.

## Details for Developers

### Measurement Logic.vi

This VI starts when the users clicks on the RUN button in the Instrument Studio.
It gets the Measurement Configuration.ctl data from the UI and starts with the initialization of the selected XNET interface. For LIN the baudrate is fixed to 19200 bps.
Initialization / Open Session for CAN is implemented in the "Open and Setup CAN Session" for LIN is in the "Open and Setup LIN Session" subVI.

#### LIN

The VI starts a loop with 100ms rate and it reads messages (frames) and the state from the bus in each cycle and sends back to the UI (propagate) with the "Update Results.vi". It converts the messages to strings with the "Convert LIN frames to Trace log.vi" subVI.

#### CAN

The VI starts a loop with 1ms rate and it reads messages (frames) from the bus and stores them in a buffer.
It sends back (propagate) the collected messages with the bus state 150ms rate by the "Update Results.vi". It converts the messages to strings with the "Convert CAN frames to Trace log.vi" subVI.

### Measurement Results.ctl
It contains the data what the logic sends back periodically to the UI. It contains:

- Message buffer (2D array of strings): the collected messages from the bus since the last "Update Result.vi" call
- Status (string) : actual bus state.
- Connection (boolean): true while the logic runs.
- OOB gRPC port (int): the port number where the OOB gRPC is listening, the UI should connect to it and propagate data to the logic. This plugin is not used OOB functionality, it was implemented for future use.
- OOB gRPC port (int): the server port that the UI's OOB client connects to retrieve measurement data.

### Measurement UI.vi
The UI diagram contains three while loops. The state-processing loop handles Initialize, Post UI Update, Exit, and Handle Error. The main UI event loop handles user interactions and trace updates, while the OOB loop receives measurement data from the service. The Initialize case also contains a for-loop that configures the UI.

#### Main UI loop
- **Timeout:** maps DBC frames and signals, processes incoming messages, updates the Trace Window and Signal Table, applies sorting and filtering, and handles Signal Table auto-scrolling. The UI retains up to the latest 10,000 rows.
- **Pause/Resume:** checked during Timeout processing rather than handled by a separate Value Change event. Messages received while paused are discarded; only messages received after resuming are displayed.
- **Clear Trace:** clears the trace data and resets the tree/table state.
- **IsRestarting?:** clears cached maps and sessions and resets trace state during a restart.
- **Save:** saves the trace data in the selected format (CSV or TDMS) and displays the result in the Status Message.
- **SortByID:** reapplies the selected ordering to the Signal Table and Trace Window.
- **Filter:** reapplies the filter to both views; clearing the filter restores the unfiltered data.
- **HELP:** opens `CAN-LIN Raw Bus Capture.pdf`.
- **Exit:** stops the UI event loop.

#### OOB loop
- **Timeout:** retrieves data from the service, converts it, and enqueues it for UI processing.
- **OOB gRPC Port:** connects the client when a valid port is provided; when the port is cleared, disconnects and flushes the queue.
- **Error:** stops the OOB client loop and reports the error.
- **Exit:** stops the OOB client loop.
