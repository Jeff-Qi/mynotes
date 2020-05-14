## 要点
1. 文件存储：把要存储的文件，如音乐、图片等以I/O流的形式存储在手机内存或者SD卡中。
2. SharedPreferences：它和XML文件存储的类型相似，都是以键值对的形式存储数据，常用这种方式存储用户登录时的用户名和密码等信息。

## 实验
1. 内外部存储读写
2. sharepreferences

## 注意事项

### 外部读写
1. Environment.getExternalStorageState() 查看外部设备是否存在
2. Environment.getExternalStorageDirectory()获取SD卡的路径，当外部设备存在时，可通过路径创建文件
3. FileInputStream、FileReader、 FileOutputStream、 FileWriter对象读写外部设备中的文件
4. 往sdcard中写入数据的权限
  ```
<uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
  ```
5. 从sdcard中读取数据的权限
  ```
<uses-permissionandroid:name="android.permission. READ_EXTERNAL_STORAGE " />
  ```


```
外部写
String environment=Environment.getExternalStorageState();
		if(Environment.MEDIA_MOUNTED.equals(environment)) {
			//外部设备可以进行读写操作
			File sd_path=Environment.getExternalStorageDirectory();
                   //if (!sd_path.exists())  {return;}
			File file=new File(sd_path,"test.txt");
			String str="Android";
			FileOutputStream fos;
			try{
				//写入数据
				fos=new FileOutputStream(file);
				OutputStreamWriter osw=new OutputStreamWriter(fos);
                           osw.write(str);
                           osw.flush();   osw.close();		fos.close();
			}
			catch(Exception exception){ 	exception.printStackTrace(); 		}
		}

外部读
String environment=Environment.getExternalStorageState();
	if(Environment.MEDIA_MOUNTED.equals(environment)) {
		//外部设备可以进行读写操作
		File sd_path=Environment.getExternalStorageDirectory();
            //if (!sd_path.exists()) {return; }
		File file=new File(sd_path,"test.txt");
		FileInputStream fis;
		try{
			//读取文件
		   fis=new FileInputStream(file);
		   InputStreamReader isr=new InputStreamReader(fis,"UTF-8");
		   char[] input=new char[fis.available()];
                 isr.read(input); String s=new String(input);
			isr.close();    fis.close();
		}
		catch(Exception exception){  exception.printStackTrace(); 		}
	}
```
### 内部读写
1. data/data/<packagename/files/,私有文件对于应用程序来讲
2. 内部存储方式使用的是Context提供的openFileOutput()方法和openFileInput()方法，通过这两个方法获取FileOutputStream对象和FileInputStream对象
  ```
1
FileOutputStream openFileOutput(String name,int mode);
FileInputStream openFileInput(String name);
openFileOutput()方法用于打开输出流，将数据存储到文件中。
openFileInput()方法用于打开输入流读取文件。
2
参数name代表文件名，mode表示文件的操作权限，它有以下几种取值：
MODE_PRIVATE: 默认的操作权限，只能被当前应用程序所读写。
MODE_APPEND: 可以添加文件的内容。
MODE_WORLD_READABLE: 可以被其他程序所读取，安全性较低。
MODE_WORLD_WRITEABLE:可以被其他的程序所写入，安全性低。
```

```
内部写入
		//文件名称
		String file_name="test.txt";
		//写入文件的数据
		String str="Android";
             FileOutputStream  fi_out
		try{
		  fi_out=openFileOutput (file_name, MODE_PRIVATE);
		  fi_out.write(str.getBytes());
		 fi_out.close();
		}
		catch(Exception exception){
			exception.printStackTrace();
		}
	}

内部读
    String file_name="test.txt";
		//保存读取的数据
		String str="";
             FileInputStream fi_in;
		try{
			fi_in=openFileInput(file_name);
			//fi_in.available()返回的实际可读字节数
			byte[] buffer=new byte[fi_in.available()];
			fi_in.read(buffer);
			str=new String(buffer);
		}
		catch(Exception exception){
			exception.printStackTrace();
		}
	}
```
```
private static final int REQUEST_EXTERNAL_STORAGE = 1;

private static String[] PERMISSIONS_STORAGE = {

        "android.permission.READ_EXTERNAL_STORAGE",

        "android.permission.WRITE_EXTERNAL_STORAGE" };

public static void verifyStoragePermissions(Activity activity) {

    try {

        //检测是否有写的权限

        int permission = ActivityCompat.checkSelfPermission(activity,

                "android.permission.WRITE_EXTERNAL_STORAGE");

        if (permission != PackageManager.PERMISSION_GRANTED) {

        // 没有写的权限，去申请写的权限，会弹出对话框

            ActivityCompat.requestPermissions(activity, PERMISSIONS_STORAGE,REQUEST_EXTERNAL_STORAGE);

        }

    } catch (Exception e) {

        e.printStackTrace();

    }

}
```

## SharedPreferences
1. SharedPreferences是用xml文件存放数据，文件存放在/data/data/<package name>/shared_prefs目录下
2. context.getSharedPreferences(name,mode),获取SharedPreferences的实例对象
  1. 方法的第一个参数用于指定该文件的名称
  2. 方法的第二个参数指定文件的操作模式
    - MODE_APPEND: 追加方式存储。
    - MODE_PRIVATE: 私有方式存储,其他应用无法访问。
    - MODE_WORLD_READABLE: 表示当前文件可以被其他应用读取。
    - MODE_WORLD_WRITEABLE: 表示当前文件可以被其他应用写入。
    - edit()方法：edit()方法获取editor对象，editor存储对象采用key-value键值对进行存放。
    - commit()方法：提交数据
3. 存数据
  1. 首先需要获取SharedPreferences对象，然后通过该对象获取到Editor对象，最后调用Editor对象的相关方法存储数据
  ```
  SharedPreferences sharedPreferences =    
            getSharedPreferences("test", Context.MODE_PRIVATE); //私有数据
  Editor editor = sharedPreferences.edit();//获取编辑器
  editor.putString("name", "江西");//存入数据
  editor.putString("history ","yejin" );
  editor.commit();//提交修改
  ```
4. 读数据
  1. 创建SharedPreferences对象，然后使用该对象从对应的key取值
  ```
  SharedPreferences sharedPreferences=context.getSharedPreferences();//获取实例对象
  String name = sharedPreferences.getString("name");获取名字
  String history = sharedPreferences.getString("history ");获取历史
  ```
5. 删除数据
  1. 获取到Editor对象，然后调用该对象的remove()方法或者clear()方法删除数据，最后提交
  ```
  SharedPreferences sharedPreferences=context.getSharedPreferences();//获取实例对象
  Editor editor = sharedPreferences.edit();//获取编辑器
  editor.remove("name");删除一条数据
  editor.clear();删除所有数据
  editor.commit();//提交修改
  ```

## Service生命周期、本地服务及广播应用

### 步骤
1. 创建Service子类
2. 在清单文件中配置

### Service的创建和配置
1. Service的创建
  - 创建一个test_Service类继承Service，此时该类会自动实现onBind()方法
  ```android
  public class test_Service extends Service {
    @Override
    public IBinder onBind(Intent intent) {
        return null;
      }
  }
  ```

2. Service的配置
  - Service是Android中的四大组件之一，因此需要在清单文件中注册
  ```android
  <application
        …
            <service android:name=".test_Service"></service>
  </application>
  ```

### Service的启动与停止
1. 通过Context的startService()方法：通过该方法启动Service，访问者与Service之间没有关联，即使访问者退出，Service也仍然在运行
  ```android
  Intent intent=new Intent(this,test_Service.class);
  startService(intent);//开启服务
  stopService(intent);//关闭服务
  ```
  1. 使用startService()和stopService()启动和关闭服务时,服务与调用者之间基本不存在太多的关联,Service无法与访问者之间进行数据交换和通信
2. 通过Context的bindService()方法：这种方式启动的Service,访问者与Service绑定在一起，访问者退出，Service也就终止了
  ```android
  Intent intent=new Intent(this,test_Service.class);
  bindService();//开启服务
  unbindService();//关闭服务
  ```

### Service的生命周期
1. startService方式启动服务的生命周期
 - 使用startService方式启动服务时，服务会先执行onCreate()方法，然后执行onStartCommand()方法，此时服务处于运行状态，直到自身调用stopSelf()方法或者访问者调用stopService()方法时服务停止，最终被系统销毁。这种方式开启的服务会长期在后台运行
2. bindService方式启动服务的生命周期
  - 服务首先被创建，接着访问者通过Ibinder接口与服务通信。访问者通过unbindService()方法关闭连接，当多个访问者能绑定的一个服务上，当他们都解除绑定时，服务就会被直接销毁
3. 服务生命周期的方法介绍
  ```
  onCreate()：第一次创建服务时执行的方法。
  onDestory()：服务被销毁时执行的方法。
  onStartCommand()：访问者通过startService(Intent service)启动服务时执行的方法。
  onBind()：使用bindService()方式启动服务调用的方法。
  onUnbind()：解除绑定时调用的方法。
  ```


echo -n | openssl s_client -connect smtp.qq.com:465 | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/pki/nssdb/qq.crt  
certutil -A -n "GeoTrust SSL CA" -t "C,," -d /etc/pki/nssdb/ -i /etc/pki/nssdb/qq.crt  
certutil -A -n "GeoTrust Global CA" -t "C,," -d /etc/pki/nssdb/ -i /etc/pki/nssdb/qq.crt  
certutil -L -d /etc/pki/nssdb/
certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu"  -d ./ -i qq.crt
