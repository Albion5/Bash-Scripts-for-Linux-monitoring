## Part 8. A ready-made dashboard

1. Run `./main.sh`

2. Set up Grafana 

    2.1 Go to *https://grafana.com/grafana/dashboards/* and download *Node Exporter Quickstart and Dashboard* 

    <img src="../misc/8.1.png">

    2.2 Go to *http://localhost:3000*

    2.3 Log in via username *admin* and password *admin* \
    <img src="../misc/8.2.png">

    2.4 Add a new connection with data source *Prometheus*

    2.5 In the prometheus server URL field type in ip address written in *prometheus.yml* file on line 11 and port 9090\
    `http://192.168.0.104:9090`

    > Ip address in that line automatically updates when you run main.sh
    >
    > It matches ip address of the network used on the local machine

    <img src="../misc/8.3.png">

    2.6 Click Save&Test button

    2.7 Go to Dashboards and import new dashboard from JSON file

    <img src="../misc/8.4.png">

    > Ip address in that file also automatically updates when you run main.sh
    >
    > It matches ip address of the network used on the local machine
    >
    > I also changed some values in that file manually like intervals, type of panels and variables

    2.8 Configure valid values for the variables in the dashboard \
    <img src="../misc/8.5.png">

3.  Check CPU, available RAM, free space and the number of I/O operations on the hard disk before and after running the script from part 2

    3.1 Before running the script \
    <img src="../misc/8.6.png">

    <img src="../misc/8.7.png">

    3.2 After running the script \
    <img src="../misc/8.8.png">

    <img src="../misc/8.9.png">

4. Check the hard disk, RAM and CPU load with the following command `stress -c 2 -i 1 -m 1 --vm-bytes 32M -t 10s` \
    <img src="../misc/8.10.png">

    <img src="../misc/8.11.png">

5. Run a network load test using **iperf3**

    5.1 Run `docker exec -it iperf bash` to execute an interactive shell inside a running Docker container named "iperf"

    5.2 Inside the container run `apt update && apt install iperf3 && iperf3 -s`

    <img src="../misc/8.12.png">

    5.3 Check the network interface load
    
    <img src="../misc/8.13.png">

    <img src="../misc/8.14.png">


