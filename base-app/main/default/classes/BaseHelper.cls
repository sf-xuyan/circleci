public class BaseHelper {
    public static void sayHi(String pkgName) {
        System.debug('20220302-0909');
        String template = 'Hi, this is {0} org!',
               msg = String.format(template, new List<String> {pkgName});
        
        System.debug(msg);
    }
}