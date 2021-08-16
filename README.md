# Lightweight HotspotClient framework

![CI-iOS](https://github.com/markoengelman/HotspotClient/workflows/CI-iOS/badge.svg)

- Simple iOS framework that helps you connect iOS device to specific Wi-Fi network from you application.
- Framework supports iOS from 11.0

## Installation
### Swift package manager

```Swift
dependencies: [
  .package(url: "https://github.com/markoengelman/HotspotClient.git", .branch("main")
]
```
## How to use
If you want to run 'Wi-Fi' validation after successfully applying configuration use ```HotspotClientWithValidation```. By default you can use already provided ```HotspotClientValidationPolicy``` or you can inject your own policy based on your needs.
```Swift
let client = NEHotspotClient(hotspotManager: .shared)
let ssidLoader = SystemSSIDLoader()
let validatedClient = HotspotClientWithValidation(
  client: client, 
  ssidLoader: ssidLoader, 
  policy: HotspotClientValidationPolicy.validateRetryCount
)

let configuration = HotspotConfiguration(
  ssid: "anySSID", /* SSID of target network */
  password: "anyPassword", /* Passhprase of target network */
  isWEP: false, 
  joincOnce: true
)

validateyClient.connect(with: configuration) { result in }
```
