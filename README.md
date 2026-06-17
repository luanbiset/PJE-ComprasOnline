# Desafio Técnico
Este documento tem o objetivo de elucidar a solução proposta para o desafio técnico
abordando boas práticas de modelagem dados, SQL avançado com procedimentos armazenados, otimização de consultas e formas seguras para realização de migração entre ambientes.

---

# 🚀 Tecnologias Utilizadas

- MySQL 8+
- SQL (DDL / DML / DCL)
- Docker (ambiente local)
- Scripts de migration versionados

---
# Parte 1 - Modelagem de Dados

## 🧱 Arquitetura do Banco de Dados

O sistema é baseado em um modelo relacional estruturado com forte integridade referencial.

## 📌 Entidades principais

- UF (`TAB_UF`)
- Cidade (`TAB_CIDADE`)
- Cliente (`TAB_CLIENTE`)
- Email do cliente (`TAB_EMAIL_CLIENTE`)
- Telefone do cliente (`TAB_TELEFONE_CLIENTE`)
- Endereço do cliente (`TAB_ENDERECO_CLIENTE`)
- Produto (`TAB_PRODUTO`)
- Pedido (`TAB_PEDIDO`)
- Item do Pedido (`TAB_ITEM_PEDIDO`)
- Status de Pedido (`TAB_STATUS_PEDIDO`)

---

# 🗄️ Padrão de Banco de Dados

## 📌 Convenção de nomenclatura utilizada para objetos 

| Objeto            | Padrão        |Exemplo  	 			   | Resumo									                                                                            |
|-------------------|--------------|-------------------------|-----------------------------------------------------------------------------------------------------------------------|
| Tabelas           | `TAB_*`      	|TAB_CLIENTE               |Objetos que representam as entidades de negócio|
| Índices           | `ALIAS_IDXSEQ`|CLI_IDX01                 |Objetos utilizados para melhorar a busca de informações nas tabelas|
| Primary Keys      | `ALIAS_PK`    |CLI_PK                    |Restrições impostas às tabelas para garantir a unicidade de uma determinada coluna,normalmente numérica e sequencial para que não se tenha dado duplicado, afetando a integridade dos dados|
| Foreign Keys      | `ALIAS_FKSEQ` |CLI_FK01                  |Restrições impostas às tabelas que possuem relacionamento direto com uma outra,evitando o que é chamado de registro órfão, quando existe na tabela filha, mas não na pai|
| Unique Keys       | `ALIAS_UKSEQ` |CLI_UK01                  |Restrições impostas às tabelas nas quais indicam que um determinado valor diferente da primary key é único,um exemplo clássico é o número de CPF, apenas uma pessoa pode possuir um determinado número de CPf|
| Check Constraints | `ALIAS_CKSEQ` |CLI_CK01                  |Restrições impostas às tabelas para obrigar que os valores aceitos por determinada coluna estejam previamente definidas, por exemplo, na coluna FLG_ATIVO só é possível registrar valores 0 e ou 1|
| Procedures        | `SP_*`        |SP_LISTAR_VENDA_PERIODO   |Procedimentos armazenados que podem ser utilizados de ínumeras formas, tais quais, processamento de dados, relatórios, etc|
| Trigger  			| `TRU/TRI/TRD_*`|TRU_ITEM_PEDIDO           |Gatilhos adicionados às tabelas para que, após uma determinada ação (Inserção, Atualização ou Exclusão) seja disparada uma segunda ação em uma outra tabela do banco de dados|


## 📌 Convenções de nomenclatura para colunas

| Padrão		    | Tipo de dado     			|Resumo 									|				Exemplo                 |
|-------------------|-----------------------|-------------------------------------------|---------------------------------------|
| IDT_*           	| `TINYINT/BIGINT`        	|Identificador da entidade					|IDT_CLIENTE							|
| NAM_*             | `VARCHAR`		   			|Nome          								|NAM_CLIENTE							|
| NUM_*		        | `NUMERIC/ALPHANUMERIC`		|Número   									|NUM_CPF								|
| FLG_*		        | `NUMERIC`        			|Indica se o valor é verdadeiro ou falso    |FLG_ATIVO								|
| VAL_*				| `Decimal`        			|Valor       								|VAL_TOTAL_PEDIDO						|
| DES_*		        | `VARCHAR/TEXT`   			|Descrição  								|SP_LISTAR_VENDA_PERIODO				|
| DAT_*		        | `DATE/TIMESTAMP`        	|Data  										|DAT_NASCIMENTO/DAT_CRIACAO				|
| TP_*		        | `TINYINT`		        	|Tipo (Domínio)								|TP_TELEFONE							|
| SG_*		        | `CHAR`		        	|Sigla 										|SG_UF									|
| COD_*		        | `VARCHAR/BIGINT/TINYINT``	|Código				 						|COD_UF									|

## 📌 Padrão de ALIAS utilizados.

Os padrões adotados para a criação de índices, foreign keys, unique constraints, check constraints, procedures e triggers foram baseados em:
- ALIAS: Utilizar os três primeiros caracteres do nome da entidade em caso de nome simples, exemplo, 
		 TAB_CLIENTE ou utilizar os três primeiros caracteres para nomes compostos, 
		 exemplo, TAB_ITEM_PEDIDO `ITEPED, desconsiderando o prefixo.
		 
- SEQ:   Utilizar um valor sequencial para manter a organização nominal dos objetos, CLI_IDX01, CLI_IDX02..etc.

---

## 📌 Classificação de dados

Com o objetivo de garantir a governança e a segurança dos dados, foram criadas roles de sensibilidade para segregar o acesso à dados potencialmente sensíveis.

| Sensibilidade     | Resumo	     												|				Exemplo                      |
|-------------------|---------------------------------------------------------------|--------------------------------------------|
|NOT_SECURITY_APPLY | São dados acessíveis ao púbico e que não possuem nenhum tipo de segurança aplicada pelo fato de não possuir restrições legais definidas pela LGPD.        	|			 NAM_CIDADE/NAM_UF			     |
|PII                | São dados que pertencem ao cliente e que são protegidos por lei e ser devidamente tratados para que não estejam  visíveis ao público												|			NUM_CPF/DAT_NASCIMENTO/DES_EMAIL |
|STRATEGIC_FIN      | Dados da companhia que norteam a tomada de decisão financeira e contábil								|			VAL_TOTAL_PEDIDO                 |
|STRATEGIC_OPE	    | Dados da companhia que norteam a tomada de decisão operacional no dia dia       						|			QTD_ITEM_PEDIDO					 |

---

## 📌 Estrutura de migrations

```text
/docker
 /migration
````

Os scripts para criação dos objetos do banco de dados podem ser encontrados na pasta [pje/migration](https://github.com/luanbiset/PJE-ComprasOnline/tree/main/pje/migration). Esses scripts estão preparados de forma idempotente, podendo ser reexecutado sem a ocorrencia de erros.

## 📌 Docker Compose

Para facilitar a inicialização do banco de dados, foi utilizado o Docker Compose para instanciá-lo e posteriormente aplicar os migrations. Na estrutura do docker, há um arquivo de configuração [docker-compose.yml](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/docker-compose.yml) onde estão definidos os parâmetros de configuração do banco de dados e flyway bem como o arquivo de configuração das variáveis de ambiente.

### Inicialização do Banco de Dados.

Para realizar a inicialização do banco de dados, deve-se seguir os passos abaixo:
- Ter o docker compose instalado na sua máquina local;
- Realizar o download/clone dos arquivos do [repositório](https://github.com/luanbiset/PJE-ComprasOnline);
- Executar o arquivo [docker-compose-run](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/docker-compose-run.bat).

O arquivo [docker-compose-run](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/docker-compose-run.bat) foi criado para que ao ser executado, instancie o banco de dados e aplique os migrations.

## 📌 MER do banco de dados.
![MER](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/pje_adm.png)

# Parte 2 - SQL Avançado e Procedimentos Armazenados
Para esta etapa, foi desenolvido o procedimento [SP_LISTAR_VENDAS_PERIODO](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/pje/migration/V012_0__CREATE_PROC_SP_LISTAR_VENDAS_PERIODO.sql), procedimento este, responsável por retornar os dados:
- Total de pedidos;
- Soma do valor total dos pedidos;
- Valor médio por pedido;
- Lista de produtos da categoria selecionada e quantidade de produtos vendidos no período.
```
Para realizar a chamada da procedure, execute o comando abaixo:

USE pje_adm;

CALL pje_adm.sp_listar_venda_periodo('2026-01-01','2026-06-30','Games',@report);

SELECT @report AS lista_venda_periodo;
```

# Parte 3 - Otimização de Query.
Para esta situação, foram realizadas as seguintes modificações:
- Estabelecidos alguns filtros obrigatórios (Data de inicio/fim, status do pedido e valor mínimo);
- Estabelecida uma regra para que o período de datas que se deseja selecionar não tenha mais de 90 dias, evitando uma consulta muito custosa no banco de dados que pode acarretar em uso excessivo de recursos;
- Estabelecida uma paginação mínima para caso o usuário não informe (50 registros por página);
- Estabelecido um status padrão (Concluído) caso o usuário não informe;
- Foi criado um índice para as colunas DAT_PEDIDO,IDT_STATUS_PEDIDO, cobrindo a consulta nas clausula where/and.
- Foi implementada uma procedure para encapsular a consulta e suas melhorias no arquivo [SP_LISTAR_POR_VALOR_MINIMO](https://github.com/luanbiset/PJE-ComprasOnline/blob/main/pje/migration/V013_0__CREATE_PROC_SP_LISTAR_POR_VALOR_MINIMO.sql).

```
Para realizar a chamada da procedure, utilize o comando abaixo:

USE pje_adm;
CALL pje_adm.sp_listar_pedido_valor_min('2026-06-01','2026-06-30','Games','Pendente',NULL,NULL,NULL);

Para este caso não se faz necessário uma variável OUT para expor o resultado pelo fato da consulta não requerer uma 
