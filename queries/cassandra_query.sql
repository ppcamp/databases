-- create keyspace keyspace_name with replication = {'class': 'SimpleStrategy', 'replication_factor': 1};

create keyspace mydb with replication = {
    'class': 'NetworkTopologyStrategy',
    'BR_SP': 1,
    'US_EAST': 2
};

desc keyspaces;


use mydb;

create table users (
    id uuid primary key,
    first_name text,
    last_name text,
    email text
);

insert into users (id, first_name, last_name, email)
values (uuid(), 'John', 'Doe', 'teste@gmail.com');

select * from users;

create table users_by_email (
    email text primary key,
    id uuid
);

create table logs_by_date (
    log_date date,
    log_time time,
    log_level text,
    log_id uuid,
    message text,
    primary key (log_date, log_time)
) with clustering order by (log_time desc);

create table logs_by_level (
    log_level text,
    log_date date,
    log_time time,
    log_id uuid,
    message text,
    primary key ((log_level, log_date), log_time)
) with clustering order by (log_time desc);

create table logs_by_id (
    log_level text,
    log_date date,
    log_time time,
    message text,
    log_id uuid,
    primary key (log_id, log_date, log_time)
) with clustering order by (log_date desc, log_time desc);

