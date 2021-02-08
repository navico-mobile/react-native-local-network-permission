
# react-native-local-network-permission
A temporary lib to handle the local network permission after iOS 14  

## Getting started

`$ npm install react-native-local-network-permission --save`

### Mostly automatic installation

`$ react-native link react-native-local-network-permission`

### Manual installation


#### iOS

1. In XCode, in the project navigator, right click `Libraries` ➜ `Add Files to [your project's name]`
2. Go to `node_modules` ➜ `react-native-local-network-permission` and add `RNLocalNetworkPermission.xcodeproj`
3. In XCode, in the project navigator, select your project. Add `libRNLocalNetworkPermission.a` to your project's `Build Phases` ➜ `Link Binary With Libraries`
4. Run your project (`Cmd+R`)<


## Usage
```javascript
import {checkLocalNetworkAccess,requestLocalNetworkAccess} from 'react-native-local-network-permission';

//you need to make sure the local network permission dialog popup once
await requestLocalNetworkAccess();

//then use checkLocalNetworkAccess when you need
await checkLocalNetworkAccess();
//here run the code depends local network access
```
  