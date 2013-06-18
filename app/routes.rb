match 'login' => 'authentication#login'
match 'logout' => 'authentication#logout'

match 'show servers' => 'servers#index'
match 'show server :id' => 'servers#show'
match 'create server' => 'servers#create'
match 'update server :id' => 'servers#update'
match 'destroy server :id' => 'servers#destroy'

match 'deploy repo :repo to server :id' => 'servers#deploy'

match 'show loadbalancers' => 'loadbalancers#index'
match 'show loadbalancer :id' => 'loadbalancers#show'
match 'create loadbalancer with node at address :ip_address' => 'loadbalancers#create'
match 'update loadbalancer :id' => 'loadbalancers#update'
match 'destroy loadbalancer :id' => 'loadbalancers#destroy'

match 'show nodes on loadbalancer :loadbalancer_id' => 'nodes#index'
match 'show node :id on loadbalancer :loadbalancer_id' => 'nodes#show'
match 'create node on loadbalancer :loadbalancer_id at address :ip_address' => 'nodes#create'
match 'update node :id on loadbalancer :loadbalancer_id' => 'nodes#update'
match 'destroy node :id on loadbalancer :loadbalancer_id' => 'nodes#destroy'

match 'show dbinstances' => 'instances#index'
match 'show dbinstance :id' => 'instances#show'
match 'create dbinstance' => 'instances#create'
match 'update dbinstance :id' => 'instances#update'
match 'destroy dbinstance :id' => 'instances#destroy'

match 'show databases on dbinstance :instance_id' => 'databases#index'
match 'show database :id on dbinstance :instance_id' => 'databases#show'
match 'create database on dbinstance :instance_id' => 'databases#create'
match 'update database :id on dbinstance :instance_id' => 'databases#update'
match 'destroy database :id on dbinstance :instance_id' => 'databases#destroy'

match 'ssh :id' => 'servers#ssh'

match 'show containers' => 'containers#index'
match 'show container :id' => 'containers#show'
match 'create container' => 'containers#create'
match 'update container :id' => 'containers#update'
match 'destroy container :id' => 'containers#destroy'

match 'show files in container :container_id' => 'files#index'
match 'show file :id in container :container_id' => 'files#show'
match 'create file :id in container :container_id' => 'files#create'
match 'update file :id in container :container_id' => 'files#update'
match 'destroy file :id in container :container_id' => 'files#destroy'
match 'download file :id in container :container_id' => 'files#download'

match 'show volumes' => 'volumes#index'
match 'show volume :id' => 'volumes#show'
match 'create volume' => 'volumes#create'
match 'update volume :id' => 'volumes#update'
match 'destroy volume :id' => 'volumes#destroy'

match 'show attachments on server :server_id' => 'attachments#index'
match 'attach volume :id to server :server_id' => 'attachments#attach'
match 'detach volume :id from server :server_id' => 'attachments#detach'
