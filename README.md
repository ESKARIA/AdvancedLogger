# AdvancedLogger
We create logger for our app. This framework in developing!
All operation execution in orher queue and you shouldnt think about manage queue

# Usage

## Standart use

1) Import in project

```swift
import AdvancedLogger
```

2) For write log use this with [model of log](Structs.html#/s:14AdvancedLogger0aB5ModelV) with [type of log](Enums/AdvancedLoggerEvent.html)

```swift
AdvancedLogger.shared.addNew(log: *MODEL OF LOG*, type: *TYPE OF LOG)
```

3) For read log in AdvancedLoggerModel use this

```swift
AdvancedLogger.shared.getLogs { (model) in }
```
where [model](Structs.html#/s:14AdvancedLogger0aB5ModelV)  -  array of logs

4) For read in JSON Encoding Data fromat use 

```swift
AdvancedLogger.shared.getJSONDataLogs { (model) in }
```
where  model - Data encoding JSON array of logs

5) For clean logs use 

```swift
AdvancedLogger.shared.cleanLogs()
```

## Crypto

Our framework support crypto encode\decode
For use crypto in logs set crypto to enable

```swift
AdvancedLogger.shared.encryptData = true
```

For use custom keys use this:

```swift
AdvancedLogger.shared.aesCryptoKeys = ALAESCryptoInitModel(cryptoKey: *YOUR KEY*, initialVector: *YOUR VALUE*)
```

## Memory usage

All logs stored on FileManager of devices. And it use auto clean logs (on FIFO principle). 

You can set custom size of logs in byte count format 

```swift
AdvancedLogger.shared.logFileSize = 1024
```

