create table "user"
(
    id        uuid      default gen_random_uuid()            not null primary key,
    user_name varchar                                        not null,
    email     varchar                                        not null,
    password  varchar                                        not null,
    photo_url varchar,
    roles     varchar[] default array ['DEFAULT']::varchar[] not null
);

create table route
(
    id               uuid default gen_random_uuid() not null
        primary key,
    user_id          uuid
        references "user",
    route_name       varchar,
    description      varchar,
    duration         double precision,
    length           double precision,
    start_point      varchar,
    end_point        varchar,
    route_preview    varchar,
    is_draft         boolean,
    last_modified_at timestamp,
    created_at       timestamp
);

create table category
(
    category_name varchar not null
        primary key
);

create table route_category
(
    route_id      uuid    not null
        references route,
    category_name varchar not null
        references category,
    primary key (route_id, category_name)
);

create table route_coordinate
(
    id           uuid default gen_random_uuid() not null
        primary key,
    route_id     uuid
        references route,
    point        geometry(Point, 4326),
    order_number integer,
    title        varchar,
    description  varchar
);

create table route_session
(
    id          uuid default gen_random_uuid() not null
        primary key,
    user_id     uuid
        references "user",
    route_id    uuid
        references route,
    is_finished boolean,
    started_at  timestamp,
    ended_at    timestamp
);

create table user_checkpoint
(
    route_session_id uuid not null
        references route_session,
    coordinate_id    uuid not null
        references route_coordinate,
    created_at       timestamp,
    primary key (route_session_id, coordinate_id)
);

create table review
(
    user_id     uuid not null
        references "user",
    route_id    uuid not null
        references route,
    mark        integer,
    review_text varchar,
    created_at  timestamp,
    primary key (user_id, route_id)
);

create table favorite
(
    user_id  uuid not null
        references "user",
    route_id uuid not null
        references route,
    primary key (user_id, route_id)
);
