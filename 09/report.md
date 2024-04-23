## Part 9. Bonus. Your own *node_exporter*

1. Run `./main.sh`

2. Set up Grafana

    2.1 Go to *http://localhost:3000*

    2.2 Log in via username *admin* and password *admin* \
    <img src="../misc/7.1.png">

    2.3 Add a new connection with data source *Prometheus* \
    <img src="../misc/7.2.png">

    2.4 In the prometheus server URL field type in ip address written in *prometheus.yml* file on line 16 and port 9090\
    `http://192.168.0.104:9090`

    > Ip address in that line automatically updates when you run main.sh
    >
    > It matches ip address of the network used on the local machine

    <img src="../misc/9.16.png">

    <img src="../misc/8.3.png">

    2.5 Click Save&Test button

    2.6 Go to Dashboards and import new dashboard from JSON file \
    <img src="../misc/7.5.png">

    > Ip address in that file also automatically updates when you run main.sh
    >
    > It matches ip address of the network used on the local machine

    2.7 Configure valid values for the variables in the dashboard \
    <img src="../misc/9.1.png">

3.  Check CPU, available RAM, free space and the number of I/O operations on the hard disk before and after running the script from part 2

    3.1 Before running the script \
    <img src="../misc/9.2.png">

    <img src="../misc/9.3.png">

    <img src="../misc/9.4.png">

    3.2 After running the script \
    <img src="../misc/9.5.png">

    <img src="../misc/9.6.png">

    <img src="../misc/9.7.png">

4. Check the hard disk, RAM and CPU load with the following command `stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s` \
    <img src="../misc/7.13.png">

    <img src="../misc/9.8.png">

    <img src="../misc/9.9.png">

    <img src="../misc/9.10.png">

    <img src="../misc/9.11.png">

    <img src="../misc/9.12.png">

    <img src="../misc/9.13.png">


    Metrics can also be displayed with another dashboard, everything works fine:

    <img src="../misc/9.14.png">

    <img src="../misc/9.15.png">

    Metrics in raw format can be seen on *http://localhost:9200/metrics*

    <img src="../misc/9.17.png">