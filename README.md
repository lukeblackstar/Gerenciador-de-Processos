# Gerenciador de Processos PowerShell

Um utilitário simples em PowerShell para monitorar e gerenciar processos em execução no sistema Windows.

## Funcionalidades

O Gerenciador de Processos oferece as seguintes funcionalidades:

- **Listar todos os processos** - Exibe todos os processos em execução ordenados por uso de CPU
- **Monitorar consumo de memória** - Identifica os 10 processos que mais consomem memória
- **Monitorar uso de CPU** - Mostra os 10 processos que mais utilizam recursos de processamento
- **Busca de processos** - Permite pesquisar processos por nome ou parte do nome
- **Encerramento por ID** - Encerra um processo específico utilizando seu identificador único
- **Encerramento por nome** - Encerra todos os processos com um determinado nome
- **Exportação para CSV** - Salva a lista completa de processos em um arquivo CSV na Área de Trabalho

## Requisitos

- Windows 7/8/10/11
- PowerShell 5.1 ou superior
- Permissões de administrador (para encerrar processos do sistema)

## Instalação

1. Baixe o arquivo `GerenciadorProcessos.ps1`
2. Não é necessário instalação adicional

## Como usar

1. Abra o PowerShell como administrador:
   - Clique com o botão direito no ícone do PowerShell
   - Selecione "Executar como administrador"

2. Navegue até o diretório onde o script está salvo:
   ```powershell
   cd caminho\para\o\diretorio
   ```

3. Execute o script:
   ```powershell
   .\GerenciadorProcessos.ps1
   ```
   
## Observações importantes

- O encerramento de processos do sistema pode causar instabilidade
- Sempre confirme antes de encerrar qualquer processo
- Os arquivos CSV exportados são salvos na Área de Trabalho com data e hora no nome

## Personalização

Você pode modificar o script para:
- Alterar o número de processos exibidos nas listas de alto consumo
- Personalizar as colunas exibidas nas tabelas
- Adicionar novas funcionalidades como monitoramento em tempo real

## Solução de problemas

**Erro de execução de scripts**

Se receber o erro "A execução de scripts foi desabilitada neste sistema", execute:
```powershell
Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope Process
```
E tente novamente.

**Permissão negada ao encerrar processos**

Certifique-se de estar executando o PowerShell como administrador.
