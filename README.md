# Flutter notification

Store device keys and send a notification

Steps for sendind notification: 

1. Create a Firebase project and add to Flutter (https://firebase.google.com/docs/flutter/setup)

2. Download service_account_key.json from the Firebase(setting/Project Settings/ Service accounts)

3.  Rename the service acoount key to  "service_account_key.json"

4. Add service_account_key.json to the root of send_notification.py

5. Copy the server key from the Firebase(setting/Project Settings/ Cloud Messaging)

6. Set server_token value to the server key value
```python
  def send_notification():
    device_tokens = get_device_tokens()
    server_token = 'server token'
    headers = {
        'Content-Type': 'application/json',
        'Authorization': 'key=' + server_token,
    }
    for deviceToken in device_toke
    ....
```
7. Go to Android Manifest and add:

  - <intent-filter>
       <action android:name="FLUTTER_NOTIFICATION_CLICK"/>
       <category android:name="android.intent.category.DEFAULT"/>
    </intent-filter>

8. Go to android/app/build.gradle and add :
```
-  dependencies {
    implementation "org.jetbrains.kotlin:kotlin-stdlib-jdk7:$kotlin_version"
    
    implementation platform('com.google.firebase:firebase-bom')
    implementation 'androidx.multidex:multidex:2.0.1'
    implementation 'com.google.firebase:firebase-core:16.0.8'
    implementation 'com.google.android.gms:play-services-basement:17.5.0'
    implementation 'com.google.firebase:firebase-analytics:18.0.0'
    implementation 'com.google.firebase:firebase-messaging:21.0.0'
  }
```
