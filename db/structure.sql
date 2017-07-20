--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET lock_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


--
-- Name: pg_stat_statements; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pg_stat_statements WITH SCHEMA public;


--
-- Name: EXTENSION pg_stat_statements; Type: COMMENT; Schema: -; Owner: -
--

COMMENT ON EXTENSION pg_stat_statements IS 'track execution statistics of all SQL statements executed';


SET search_path = public, pg_catalog;

--
-- Name: median(anyarray); Type: FUNCTION; Schema: public; Owner: -
--

CREATE FUNCTION median(anyarray) RETURNS double precision
    LANGUAGE sql IMMUTABLE
    AS $_$
        WITH q AS
        (
           SELECT val
           FROM unnest($1) val
           WHERE VAL IS NOT NULL
           ORDER BY 1
        ),
        cnt AS
        (
          SELECT COUNT(*) AS c FROM q
        )
        SELECT AVG(val)::float8
        FROM
        (
          SELECT val FROM q
          LIMIT  2 - MOD((SELECT c FROM cnt), 2)
          OFFSET GREATEST(CEIL((SELECT c FROM cnt) / 2.0) - 1,0)
        ) q2;
      $_$;


--
-- Name: median(anyelement); Type: AGGREGATE; Schema: public; Owner: -
--

CREATE AGGREGATE median(anyelement) (
    SFUNC = array_append,
    STYPE = anyarray,
    INITCOND = '{}',
    FINALFUNC = public.median
);


SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: home_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE home_types (
    id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: home_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE home_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: home_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE home_types_id_seq OWNED BY home_types.id;


--
-- Name: home_viewers; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE home_viewers (
    id integer NOT NULL,
    user_id integer,
    home_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: home_viewers_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE home_viewers_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: home_viewers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE home_viewers_id_seq OWNED BY home_viewers.id;


--
-- Name: homes; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE homes (
    id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    name text NOT NULL,
    owner_id integer NOT NULL,
    is_public boolean DEFAULT false NOT NULL,
    home_type_id integer,
    rooms_count integer,
    sensors_count integer
);


--
-- Name: homes_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE homes_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: homes_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE homes_id_seq OWNED BY homes.id;


--
-- Name: messages; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE messages (
    id integer NOT NULL,
    node_id integer,
    message_type character varying,
    child_sensor_id integer,
    ack integer,
    sub_type integer,
    payload text,
    sensor_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: messages_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE messages_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: messages_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE messages_id_seq OWNED BY messages.id;


--
-- Name: mqtt_users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE mqtt_users (
    id integer NOT NULL,
    user_id integer,
    username character varying,
    password character varying,
    provisioned_at timestamp without time zone,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: mqtt_users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE mqtt_users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: mqtt_users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE mqtt_users_id_seq OWNED BY mqtt_users.id;


--
-- Name: old_readings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE old_readings (
    id integer NOT NULL,
    sensor_id integer,
    key text,
    value double precision,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    message_type character varying,
    child_sensor_id integer,
    ack integer,
    sub_type integer
);


--
-- Name: old_readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE old_readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: old_readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE old_readings_id_seq OWNED BY old_readings.id;


--
-- Name: readings; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE readings (
    id integer NOT NULL,
    room_id integer NOT NULL,
    key text NOT NULL,
    value double precision NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: readings_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE readings_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: readings_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE readings_id_seq OWNED BY readings.id;


--
-- Name: roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE roles (
    id integer NOT NULL,
    name character varying NOT NULL,
    friendly_name character varying NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE roles_id_seq OWNED BY roles.id;


--
-- Name: room_types; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE room_types (
    id integer NOT NULL,
    name text NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    min_temperature double precision,
    max_temperature double precision
);


--
-- Name: room_types_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE room_types_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: room_types_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE room_types_id_seq OWNED BY room_types.id;


--
-- Name: rooms; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE rooms (
    id integer NOT NULL,
    home_id integer NOT NULL,
    name text,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    room_type_id integer,
    readings_count integer
);


--
-- Name: rooms_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE rooms_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: rooms_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE rooms_id_seq OWNED BY rooms.id;


--
-- Name: schema_migrations; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE schema_migrations (
    version character varying NOT NULL
);


--
-- Name: sensors; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE sensors (
    id integer NOT NULL,
    room_id integer,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL,
    node_id integer NOT NULL,
    home_id integer NOT NULL,
    messages_count integer
);


--
-- Name: sensors_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE sensors_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: sensors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE sensors_id_seq OWNED BY sensors.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE user_roles (
    id integer NOT NULL,
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: user_roles_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE user_roles_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: user_roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE user_roles_id_seq OWNED BY user_roles.id;


--
-- Name: users; Type: TABLE; Schema: public; Owner: -; Tablespace: 
--

CREATE TABLE users (
    id integer NOT NULL,
    email character varying DEFAULT ''::character varying NOT NULL,
    encrypted_password character varying DEFAULT ''::character varying NOT NULL,
    reset_password_token character varying,
    reset_password_sent_at timestamp without time zone,
    remember_created_at timestamp without time zone,
    sign_in_count integer DEFAULT 0 NOT NULL,
    current_sign_in_at timestamp without time zone,
    last_sign_in_at timestamp without time zone,
    current_sign_in_ip character varying,
    last_sign_in_ip character varying,
    created_at timestamp without time zone NOT NULL,
    updated_at timestamp without time zone NOT NULL
);


--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: -
--

CREATE SEQUENCE users_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: -
--

ALTER SEQUENCE users_id_seq OWNED BY users.id;


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_types ALTER COLUMN id SET DEFAULT nextval('home_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_viewers ALTER COLUMN id SET DEFAULT nextval('home_viewers_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY homes ALTER COLUMN id SET DEFAULT nextval('homes_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages ALTER COLUMN id SET DEFAULT nextval('messages_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY mqtt_users ALTER COLUMN id SET DEFAULT nextval('mqtt_users_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY old_readings ALTER COLUMN id SET DEFAULT nextval('old_readings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY readings ALTER COLUMN id SET DEFAULT nextval('readings_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY roles ALTER COLUMN id SET DEFAULT nextval('roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY room_types ALTER COLUMN id SET DEFAULT nextval('room_types_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY rooms ALTER COLUMN id SET DEFAULT nextval('rooms_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY sensors ALTER COLUMN id SET DEFAULT nextval('sensors_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY user_roles ALTER COLUMN id SET DEFAULT nextval('user_roles_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: -
--

ALTER TABLE ONLY users ALTER COLUMN id SET DEFAULT nextval('users_id_seq'::regclass);


--
-- Name: home_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY home_types
    ADD CONSTRAINT home_types_pkey PRIMARY KEY (id);


--
-- Name: home_viewers_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY home_viewers
    ADD CONSTRAINT home_viewers_pkey PRIMARY KEY (id);


--
-- Name: homes_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY homes
    ADD CONSTRAINT homes_pkey PRIMARY KEY (id);


--
-- Name: messages_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT messages_pkey PRIMARY KEY (id);


--
-- Name: mqtt_users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY mqtt_users
    ADD CONSTRAINT mqtt_users_pkey PRIMARY KEY (id);


--
-- Name: old_readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY old_readings
    ADD CONSTRAINT old_readings_pkey PRIMARY KEY (id);


--
-- Name: readings_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY readings
    ADD CONSTRAINT readings_pkey PRIMARY KEY (id);


--
-- Name: roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: room_types_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY room_types
    ADD CONSTRAINT room_types_pkey PRIMARY KEY (id);


--
-- Name: rooms_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT rooms_pkey PRIMARY KEY (id);


--
-- Name: sensors_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY sensors
    ADD CONSTRAINT sensors_pkey PRIMARY KEY (id);


--
-- Name: user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (id);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: -; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: index_home_viewers_on_user_id_and_home_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_home_viewers_on_user_id_and_home_id ON home_viewers USING btree (user_id, home_id);


--
-- Name: index_homes_on_is_public; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_homes_on_is_public ON homes USING btree (is_public);


--
-- Name: index_homes_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_homes_on_name ON homes USING btree (name);


--
-- Name: index_homes_on_owner_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_homes_on_owner_id ON homes USING btree (owner_id);


--
-- Name: index_messages_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_created_at ON messages USING btree (created_at);


--
-- Name: index_messages_on_sensor_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_messages_on_sensor_id ON messages USING btree (sensor_id);


--
-- Name: index_readings_on_created_at; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_readings_on_created_at ON readings USING btree (created_at);


--
-- Name: index_readings_on_key; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_readings_on_key ON readings USING btree (key);


--
-- Name: index_readings_on_key_and_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_readings_on_key_and_room_id ON readings USING btree (key, room_id);


--
-- Name: index_readings_on_room_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_readings_on_room_id ON readings USING btree (room_id);


--
-- Name: index_roles_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_roles_on_name ON roles USING btree (name);


--
-- Name: index_rooms_on_home_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rooms_on_home_id ON rooms USING btree (home_id);


--
-- Name: index_rooms_on_name; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_rooms_on_name ON rooms USING btree (name);


--
-- Name: index_sensors_on_node_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_sensors_on_node_id ON sensors USING btree (node_id);


--
-- Name: index_user_roles_on_role_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_roles_on_role_id ON user_roles USING btree (role_id);


--
-- Name: index_user_roles_on_user_id; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX index_user_roles_on_user_id ON user_roles USING btree (user_id);


--
-- Name: index_users_on_email; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_email ON users USING btree (email);


--
-- Name: index_users_on_reset_password_token; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX index_users_on_reset_password_token ON users USING btree (reset_password_token);


--
-- Name: readings_room_id_idx; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE INDEX readings_room_id_idx ON readings USING btree (room_id);


--
-- Name: unique_schema_migrations; Type: INDEX; Schema: public; Owner: -; Tablespace: 
--

CREATE UNIQUE INDEX unique_schema_migrations ON schema_migrations USING btree (version);


--
-- Name: fk_rails_2df398b927; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sensors
    ADD CONSTRAINT fk_rails_2df398b927 FOREIGN KEY (room_id) REFERENCES rooms(id);


--
-- Name: fk_rails_3f8e0be05c; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY messages
    ADD CONSTRAINT fk_rails_3f8e0be05c FOREIGN KEY (sensor_id) REFERENCES sensors(id);


--
-- Name: fk_rails_407bfe92b8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY readings
    ADD CONSTRAINT fk_rails_407bfe92b8 FOREIGN KEY (room_id) REFERENCES rooms(id);


--
-- Name: fk_rails_491effc3a4; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_viewers
    ADD CONSTRAINT fk_rails_491effc3a4 FOREIGN KEY (home_id) REFERENCES homes(id);


--
-- Name: fk_rails_5ff3a86b0d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY mqtt_users
    ADD CONSTRAINT fk_rails_5ff3a86b0d FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_642c09c018; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY sensors
    ADD CONSTRAINT fk_rails_642c09c018 FOREIGN KEY (home_id) REFERENCES homes(id);


--
-- Name: fk_rails_7fa03a49bd; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY homes
    ADD CONSTRAINT fk_rails_7fa03a49bd FOREIGN KEY (home_type_id) REFERENCES home_types(id);


--
-- Name: fk_rails_906c6d825b; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY home_viewers
    ADD CONSTRAINT fk_rails_906c6d825b FOREIGN KEY (user_id) REFERENCES users(id);


--
-- Name: fk_rails_f4fff90e9d; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY rooms
    ADD CONSTRAINT fk_rails_f4fff90e9d FOREIGN KEY (room_type_id) REFERENCES room_types(id);


--
-- Name: fk_rails_f8d62802f8; Type: FK CONSTRAINT; Schema: public; Owner: -
--

ALTER TABLE ONLY homes
    ADD CONSTRAINT fk_rails_f8d62802f8 FOREIGN KEY (owner_id) REFERENCES users(id);


--
-- PostgreSQL database dump complete
--

SET search_path TO "$user",public;

INSERT INTO schema_migrations (version) VALUES ('20160922042938');

INSERT INTO schema_migrations (version) VALUES ('20160922043308');

INSERT INTO schema_migrations (version) VALUES ('20160922043312');

INSERT INTO schema_migrations (version) VALUES ('20160922044007');

INSERT INTO schema_migrations (version) VALUES ('20160925014310');

INSERT INTO schema_migrations (version) VALUES ('20160925014902');

INSERT INTO schema_migrations (version) VALUES ('20160925015014');

INSERT INTO schema_migrations (version) VALUES ('20160925063312');

INSERT INTO schema_migrations (version) VALUES ('20160928003715');

INSERT INTO schema_migrations (version) VALUES ('20160928030123');

INSERT INTO schema_migrations (version) VALUES ('20160928054557');

INSERT INTO schema_migrations (version) VALUES ('20160928054744');

INSERT INTO schema_migrations (version) VALUES ('20161010002942');

INSERT INTO schema_migrations (version) VALUES ('20161010015255');

INSERT INTO schema_migrations (version) VALUES ('20161010021309');

INSERT INTO schema_migrations (version) VALUES ('20161203031122');

INSERT INTO schema_migrations (version) VALUES ('20161217062517');

INSERT INTO schema_migrations (version) VALUES ('20161217212517');

INSERT INTO schema_migrations (version) VALUES ('20170310013556');

INSERT INTO schema_migrations (version) VALUES ('20170310020006');

INSERT INTO schema_migrations (version) VALUES ('20170316212835');

INSERT INTO schema_migrations (version) VALUES ('20170318072229');

INSERT INTO schema_migrations (version) VALUES ('20170323214453');

INSERT INTO schema_migrations (version) VALUES ('20170324011548');

INSERT INTO schema_migrations (version) VALUES ('20170416021403');

INSERT INTO schema_migrations (version) VALUES ('20170707012401');

INSERT INTO schema_migrations (version) VALUES ('20170719025235');

