public class BaseHelper {
    public static void sayHi(String pkgName) {
        String template = 'Hi, this is {0} org!',
               msg = String.format(template, new List<String> {pkgName});
        
        System.debug(msg);
    }
}