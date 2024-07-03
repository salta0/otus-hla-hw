SELECT citus_set_coordinator_host('citus_master');

CREATE TABLE threads (
    id SERIAL PRIMARY KEY,
    participants uuid[],
    created_at timestamp DEFAULT NOW()
);

CREATE TABLE messages (
    id SERIAL,
    thread_id bigint NOT NULL,
    from_user_id uuid NOT NULL,
    to_user_id uuid NOT NULL, 
    body text,
    created_at timestamp DEFAULT NOW()
);

SELECT * from citus_add_node('citus_worker_1', 5432);
SELECT * from citus_add_node('citus_worker_2', 5432);

SELECT create_distributed_table('threads', 'id');
SELECT create_distributed_table('messages', 'thread_id'); 

CREATE UNIQUE INDEX thread_id_id_messages_idx ON messages (thread_id, id);
ALTER TABLE messages REPLICA IDENTITY USING INDEX thread_id_id_messages_idx;

CREATE INDEX participants_threads_idx ON threads (participants);
CREATE INDEX thread_id_messages_idx ON messages (thread_id);
CREATE INDEX created_at_messages_idx ON messages (created_at);
