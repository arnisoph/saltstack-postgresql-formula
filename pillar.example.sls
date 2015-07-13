postgresql:
  lookup:
    repo:
      state: managed
      name: deb http://apt.postgresql.org/pub/repos/apt/ {{ salt['grains.get']('oscodename') }}-pgdg main
      file: /etc/apt/sources.list.d/postgresql-{{ salt['grains.get']('oscodename') }}.list
      key_url: https://www.postgresql.org/media/keys/ACCC4CF8.asc
    client:
      pkgs:
        - postgresql-client-9.4
        - python-pygresql
    server:
      pkgs:
        - postgresql-9.4
        - postgresql-contrib-9.4
      cluster:
        version: 9.4
        directory: /data/postgresl/9.4/main
      config:
        manage:
          - postgresql
          - pg_hba
        postgresql:
          path: /etc/postgresql/9.4/main/postgresql.conf
          config:
            sections:
              - name: FILE LOCATIONS
                data_directory: '/data/postgresql/9.4/main'
                hba_file: '/etc/postgresql/9.4/main/pg_hba.conf'
                ident_file: '/etc/postgresql/9.4/main/pg_ident.conf'
                external_pid_file: '/var/run/postgresql/9.4-main.pid'
              - name: CONNECTIONS AND AUTHENTICATION
                listen_addresses: '*'
                port: 5432
                max_connections: 100
                unix_socket_directories: '/var/run/postgresql'
                ssl: 'true'
                ssl_cert_file: '/etc/ssl/certs/ssl-cert-snakeoil.pem'          # (change requires restart)
                ssl_key_file: '/etc/ssl/private/ssl-cert-snakeoil.key'
              - name: RESOURCE USAGE (except WAL)
                shared_buffers: '128MB'
                dynamic_shared_memory_type: posix
              - name: ERROR REPORTING AND LOGGING
                log_line_prefix: '%t [%p-%l] %q%u@%d '
              - name: RUNTIME STATISTICS
                stats_temp_directory: '/var/run/postgresql/9.4-main.pg_stat_tmp'
              - name: CLIENT CONNECTION DEFAULTS
                datestyle: 'iso, dmy'
                timezone: 'localtime'
                lc_messages: 'C'
                lc_monetary: 'C'
                lc_numeric: 'C'
                lc_time: 'C'
                default_text_search_config: 'pg_catalog.english'
        pg_hba:
          path: /etc/postgresql/9.4/main/pg_hba.conf
          config:
            - name: Database administrative login by Unix domain socket
              type: local
              database: all
              user: postgres
              auth_method: peer
            - name: local is for Unix domain socket connections only
              type: local
              database: all
              user: all
              auth_method: peer
            - name: IPv4 local connections
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
            - name: IPv4 connections
              type: host
              database: all
              user: all
              address: 10.0.0.0/8
              auth_method: md5
            - name: IPv6 local connections
              type: host
              database: all
              user: all
              address: fd57:c87d:f1ee::/48
              auth_method: md5
  users:
    - name: foreman
      password: foreman
    - name: foo
      password: bar
  databases:
    - name: foreman
    - name: foo
