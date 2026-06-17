-- Criação do schema utlizando charset e collation utf8mb4.
CREATE SCHEMA IF NOT EXISTS pje_adm DEFAULT CHARACTER SET utf8mb4 DEFAULT COLLATE utf8mb4_unicode_ci;

-- Criação dos usuários e suas respectivas senhas.
CREATE USER pje_adm@'%' IDENTIFIED WITH mysql_native_password BY 's6bfK1NAz7U8';
CREATE USER pje_ubr@'%' IDENTIFIED WITH mysql_native_password BY'dqF1BD2S96UJ';

-- Criação das roles de controle de usuário da aplicação e usuário de migration
CREATE ROLE rl_pje_adm;
CREATE ROLE rl_pje_ubr;

-- Criação das roles de sensibilidade de dados para tabelas que por ventura possuam dados sensíveis.
CREATE ROLE rl_compliance_nsa;
CREATE ROLE rl_compliance_pii;
CREATE ROLE rl_compliance_strategic_fin;
CREATE ROLE rl_compliance_strategic_ope;

-- Atribuição da role para o respectivo usuário.
GRANT rl_pje_adm TO pje_adm@'%';
GRANT rl_pje_ubr TO pje_ubr@'%';

SET DEFAULT ROLE rl_pje_adm TO pje_adm@'%';
SET DEFAULT ROLE rl_pje_ubr TO pje_ubr@'%';

-- Concessão de privilégios para a role visando centralizar e padronizar as permissões que os usuários associados à elas possuem.
GRANT ALL PRIVILEGES                 ON pje_adm.* TO pje_adm@'%';
GRANT ALL PRIVILEGES                 ON pje_adm.* TO rl_pje_adm;
GRANT SELECT, INSERT, UPDATE, DELETE ON pje_adm.* TO rl_pje_ubr;