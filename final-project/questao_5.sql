-- bloqueio exclusivo para update
	BEGIN;
SELECT * FROM contas WHERE id = 1 FOR UPDATE; 
UPDATE contas SET saldo = saldo + 100 WHERE id =1;
COMMIT;
BEGIN;
	-- bloqueio compartilhado permite leitura mas não escrita
SELECT * FROM contas WHERE saldo > 0 FOR SHARE;
COMMIT;

