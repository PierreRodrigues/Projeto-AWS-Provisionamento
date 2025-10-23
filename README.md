Globotech + ADA
Aqui envio meus projetos sendo feitos no programa da Globo junto com a escola de tecnologia ADA

> GloboTech > Segundo Módulo
> projeto orientado a objetos com python
> 
# Projeto Unificado - Fase 2
Análise de Engajamento de Mídias Globo com Orientação a Objetos
🧠 Objetivo
Este projeto visa aplicar os princípios da Programação Orientada a Objetos (POO) em Python, evoluindo a base de código da Fase 1 para uma estrutura mais modular, robusta e extensível, com foco na análise de engajamento em mídias da Globo.

📚 Módulo: DS-PY-02 (Programação Orientada a Objetos - Python)
📦 Estrutura do Projeto

# projeto_engajamento_fase2/
<pre>```
├── main.py                      # Script principal de execução
├── interacoes_globo.csv        # Arquivo com os dados de interações
├── entidades/
│   ├── __init__.py
│   ├── plataforma.py           # Classe Plataforma
│   ├── conteudo.py             # Conteudo base e subclasses: Video, Podcast, Artigo
│   ├── interacao.py            # Classe Interacao
│   └── usuario.py              # Classe Usuario
├── analise/
│   ├── __init__.py
│   └── sistema.py              # Classe SistemaAnaliseEngajamento
└── README.md                   # (Você está aqui!)```
</pre>


🧩 Classes Principais
🔹 Plataforma
Representa uma plataforma de mídia (ex: Globoplay, G1).

Atributos: id_plataforma, nome_plataforma (com validações via properties)

Métodos mágicos: __str__, __repr__, __eq__, __hash__

🔹 Conteúdo (Classe Base)
Representa um item consumível com interações.

Atributos: id_conteudo, nome_conteudo, interacoes

Métodos:

adicionar_interacao()

calcular_total_interacoes_engajamento()

listar_comentarios()

calcular_media_tempo_consumo()

e outros

🔸 Subclasses de Conteúdo
Video: inclui duracao_total_video_seg e cálculo de percentual médio assistido

Podcast: pode incluir duracao_total_episodio_seg

Artigo: possui tempo_leitura_estimado_seg

🔹 Interacao
Representa uma interação entre usuário e conteúdo em uma plataforma.

Atributos incluem: tipo_interacao, watch_duration_seconds, comment_text, plataforma, etc.

Validação rigorosa de tipo de interação: {view_start, like, share, comment}

🔹 Usuario
Armazena interações realizadas por um usuário.

Métodos:

registrar_interacao()

obter_interacoes_por_tipo()

calcular_tempo_total_consumo_plataforma()

plataformas_mais_frequentes()

🧠 Classe de Orquestração: SistemaAnaliseEngajamento
Responsável por gerenciar todas as entidades e realizar a análise:

Gerencia plataformas, conteúdos e usuários via dicionários

Realiza o carregamento e processamento de dados do CSV

Cria vínculos entre as entidades a partir dos dados

Gera relatórios como:

gerar_relatorio_engajamento_conteudos(top_n)

gerar_relatorio_atividade_usuarios(top_n)

identificar_top_conteudos(metrica, n)

Versão da análise: 2.0

▶️ Execução
Certifique-se de que o arquivo interacoes_globo.csv esteja na raiz do projeto.

Execute o script principal:

bash
Copiar
Editar
python main.py
Os relatórios de análise serão exibidos no terminal.

✅ Requisitos
Python 3.8+

Bibliotecas padrão: datetime, csv

✍️ Autores / Colaboradores
Alunos do curso de Formação em Dados - DS-PY-02
- Pierre
- Maria
- Beatriz
- Nando

Projeto orientado pelos professores do programa

📌 Notas
O projeto foca em boas práticas de POO, incluindo encapsulamento, herança, polimorfismo, validação de dados e reutilização de código.

A modularização e separação em pacotes visa facilitar manutenção, testes e extensões futuras.
