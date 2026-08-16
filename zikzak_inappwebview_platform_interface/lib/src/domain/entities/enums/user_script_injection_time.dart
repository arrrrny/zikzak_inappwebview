
import '../../../types/user_script.dart';


///Class that represents contains the constants for the times at which to inject script content into a `WebView` used by an [UserScript].
enum UserScriptInjectionTime {
  ///**NOTE for iOS**: A constant to inject the script after the creation of the webpage’s document element, but before loading any other content.
  ///
  ///**NOTE for Android**: A constant to try to inject the script as soon as the page starts loading.
  AT_DOCUMENT_START,
  ///**NOTE for iOS**: A constant to inject the script after the document finishes loading, but before loading any other subresources.
  ///
  ///**NOTE for Android**: A constant to inject the script as soon as the page finishes loading.
  AT_DOCUMENT_END,
}
