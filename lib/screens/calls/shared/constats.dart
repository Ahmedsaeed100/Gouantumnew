//Firebase Collection
// const userCollection = '_users';
// const callsCollection = 'Calls';
// const tokensCollection = 'Tokens';

const fcmKey =
    'AAAAEJxUeFs:APA91bHudQXDqMXzFBNTI3HPHELsX_szUAdnUkg58WRvN4CNU5I5TV6otAiikT2UP0hXWBxVVxK9BVD8C5NFFHwaGPjfds558YG4UPbmHhadMC3odMxNcPnHNIpHoQKsN3w4M5lcc8fY'; //replace with your Fcm key
//Routes
const loginScreen = '/';
const homeScreen = '/homeScreen';
const callScreen = '/callScreen';

//Agora
const agoraAppId =
    'db9b42692baf4d6982fd85c997c971b6'; //replace with your agora app id
//String agoraTestChannelName = ''; //replace with your agora channel name
//String agoraTestToken = ''; //replace with your agora token

// const int callDurationInSec = 45;
const int callDurationInSec = 30;

//Call Status
enum CallStatus {
  none,
  ringing,
  accept,
  reject,
  unAnswer,
  cancel,
  end,
}
