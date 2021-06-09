-- =================== --
-- Create Users        --
-- =================== --
CREATE USER rorAdmin identified by 'dino';
CREATE USER rorApp identified by 'dino write'
CREATE USER rorRead identified by 'usual';

CREATE USER molbioAdmin identified by 'dino';
CREATE USER molbioApp identified by 'dino write'
CREATE USER molbioRead identified by 'usual';

CREATE USER val_rorAdmin identified by 'usual';
CREATE USER val_rorApp identified by 'usual'
CREATE USER val_rorRead identified by 'usual';
