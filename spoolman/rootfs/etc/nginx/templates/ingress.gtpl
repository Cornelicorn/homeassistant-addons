server {
    listen {{ .address }}:{{ .port }} default_server;

    include /etc/nginx/includes/server_params.conf;
    include /etc/nginx/includes/proxy_params.conf;

    location / {
        allow   172.30.32.2;
        deny    all;

        proxy_pass http://backend;
        proxy_redirect '/' $http_x_ingress_path/;
        sub_filter 'window.SPOOLMAN_BASE_PATH = ""' 'window.SPOOLMAN_BASE_PATH = "$http_x_ingress_path"';
        sub_filter_types *;
        sub_filter 'href="/' 'href="$http_x_ingress_path/';
        sub_filter 'src="/' 'src="$http_x_ingress_path/';
        sub_filter "top.location.href='" "top.location.href='$http_x_ingress_path";

        sub_filter_once off;
    }
}
