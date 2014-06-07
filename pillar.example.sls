postgresql:
  lookup:
    server:
      config:
        postgresql:
          config:
            sections:
              - name: FILE LOCATIONS
                data_directory: '/var/lib/postgresql/9.1/main'
                hba_file: '/etc/postgresql/9.1/main/pg_hba.conf'
                ident_file: '/etc/postgresql/9.1/main/pg_ident.conf'
                external_pid_file: '/var/run/postgresql/9.1-main.pid'
              - name: CONNECTIONS AND AUTHENTICATION
                listen_addresses: '*'
                port: 5432
                max_connections: 100
                unix_socket_directory: '/var/run/postgresql'
                ssl: 'true'
              - name: RESOURCE USAGE (except WAL)
                shared_buffers: '24MB'
              - name: ERROR REPORTING AND LOGGING
                log_line_prefix: '%t '
              - name: CLIENT CONNECTION DEFAULTS
                datestyle: 'iso, mdy'
                lc_messages: 'en_US.UTF-8'
                lc_monetary: 'en_US.UTF-8'
                lc_numeric: 'en_US.UTF-8'
                lc_time: 'en_US.UTF-8'
                default_text_search_config: 'pg_catalog.english'

        pg_hba:
          config:
            - name: Database administrative login by Unix domain socket
              type: local
              database: all
              user: postgres
              auth_method: ident
            - name: local is for Unix domain socket connections only
              type: local
              database: all
              user: all
              auth_method: ident
            - name: IPv4 local connections
              type: host
              database: all
              user: postgres
              address: 127.0.0.1/32
              auth_method: md5
            - name: deny access to postgresql user
              type: host
              database: all
              user: postgres
              address: 0.0.0.0/0
              auth_method: reject
            - name: allow access to all users
              type: host
              database: all
              user: all
              address: 127.0.0.1/32
              auth_method: md5
            - name: IPv6 local connections
              type: host
              database: all
              user: all
              address: ::1/128
              auth_method: md5
  users:
    - name: foreman
      password: foreman
    - name: foo
      password: bar
  databases:
    - name: foreman
    - name: foo
