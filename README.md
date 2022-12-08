# HMI Networking
This project started on the small collection of flutter widgets 
which was build for industrial HMI application.

## Features
### - Read data from industrial controllers or/and common microcontrollers
    - PROFINET
    - Modbus - not implemented yet
    - CanBus - not implemented yet
    - IEC 60870-5-104 - not implemented yet
    - IEC 61850 MMS - not implemented yet
### - Data type convertions ond distributions to the view layer in the streams
    - int <-> bool
    - int <-> double
### - Recieving and calculating diagnostics information
    - about self
    - about communication lines
    - about connected controllers

## Getting started

TODO: List prerequisites and provide or point to information on how to
start using the package.

## Usage

TODO: Include short and useful examples for package users. Add longer examples
to `/example` folder.

```dart
Column(
    children: [
        StatusIndicatorWidget(
            width: 150.0,
            indicator: BoolColorIndicator(
                // iconData: Icons.account_tree_outlined,
                stream: Stream<DsDataPoint<bool>>,
            ), 
            caption: const Text('Constant tension')),
        ),
        TextIndicatorWidget(
            width: 150.0 - 22.0,
            indicator: TextIndicator(
                stream: Stream<DsDataPoint<int>>,
                valueUnit: '%',
            ),
            caption: Text(
                'Tension factor',
                style: Theme.of(context).textTheme.bodySmall,
            ),
            alignment: Alignment.topRight, 
        ),
    ],
)
```

## Additional information

TODO: Tell users more about the package: where to find more information, how to
contribute to the package, how to file issues, what response they can expect
from the package authors, and more.
