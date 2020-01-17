private static Connection getConnection(String dbName) {
    Connection conn = null;
    try {
        Class.forName("com.mysql.jdbc.Driver"); //加载驱动
        String ip = "182.61.2.249";
        conn = DriverManager.getConnection(
                "jdbc:mysql://" + ip + ":10000/" + android_kcsj,
                "jeff", "!qaz2WSX");
    } catch (SQLException ex) {
        ex.printStackTrace();
    } catch (ClassNotFoundException ex) {
        ex.printStackTrace();
    }
    return conn;
}
