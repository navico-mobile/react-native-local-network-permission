import { NativeModules } from 'react-native';
const { RNLocalNetworkPermission } = NativeModules;
export const checkLocalNetworkPermission = (timeOutSeconds) => {
    return RNLocalNetworkPermission.check(timeOutSeconds);
};
