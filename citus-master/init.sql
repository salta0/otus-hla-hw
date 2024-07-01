CREATE TABLE messages (
    id serial NOT NULL,
    dialog_id varchar(50) NOT NULL,
    from_user_id uuid NOT NULL,
    to_user_id uuid NOT NULL, 
    body text,
    created_at timestamp DEFAULT NOW()
);
SELECT create_distributed_table('messages', 'dialog_id'); 
CREATE UNIQUE INDEX dialog_id_id_messages_idx ON messages (dialog_id, id);
ALTER TABLE messages REPLICA IDENTITY USING INDEX dialog_id_id_messages_idx;

CREATE INDEX dialog_id_messages_idx ON messages (dialog_id);
CREATE INDEX created_at_messages_idx ON messages (created_at);

SELECT citus_set_coordinator_host('citus_master');
