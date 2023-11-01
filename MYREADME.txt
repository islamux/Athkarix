// change extends from statlesswidget to Getviw because the button
// willnot change and there will not be a refressh on ui.
//GetView is a great way of quickly access your Controller
///without having to call Get.find() yourself
-------
class CustomTextSliderAthkarSabah extends GetView<AthkarSabahControllerImp> {
  // here instead of extends from stelsswidget it replace with Getview 
  and pass AthkarSabahControllerImp to take controller from.
  // Or By Adding final instance from class and using it to access page.
        - final AthkarSabahControllerImp athkarsabahcontrollerimp;
        or by using 
        - GetView<AthkarSabahControllerImp>  from abstrct AthkarSabahController
         or normal class AthkarSabahController in the same page
        and in AthkarSabahController creat insctance to be like a controller
            - final AthkarSabahController AthkarSabahController; 
                - athkarsabahcontroller.anything in class
                IN 63 video.

------------------------
in widget ===> using Getview<AthkarSabahControllerImp>
and in view page AthkarSabahControllerImp controller = Get.put(AthkarSabahControllerImp);
---------
To make button works and make fontSize bigger, smaller, without hotreload (instantly) wrab widget
only not full page with GetBuilder<PageControllerImp>(controller)=>widget()

-------------------Fix gradle ------------
Starting a Gradle Daemon, 1 busy Daemon could not be reused, use --status for details
WARNING:We recommend using a newer Android Gradle plugin to use compileSdk = 33

This Android Gradle plugin (7.1.2) was tested up to compileSdk = 32

This warning can be suppressed by adding
    android.suppressUnsupportedCompileSdk=33
to this project's gradle.properties

The build will continue, but you are strongly encouraged to update your project to
use a newer Android Gradle Plugin that has been tested with compileSdk = 33