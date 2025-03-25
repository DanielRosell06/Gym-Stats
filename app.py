from flask import Flask, jsonify, request
from flask_cors import CORS
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from sqlalchemy.dialects.postgresql import ARRAY
import os

from dotenv import load_dotenv
load_dotenv()  # Carrega variáveis do .env

app = Flask(__name__)
CORS(app)

#Configurando o Banco de dados para acessar a URL certa
app.config['SQLALCHEMY_DATABASE_URI'] = os.environ.get('DATABASE_URL')  # Use variáveis de ambiente!
app.config['SQLALCHEMY_TRACK_MODIFICATIONS'] = False

# Inicializa o banco e o sistema de migrações.
db = SQLAlchemy(app)
migrate = Migrate(app, db)



# Modelo de exemplo (substitua pelo seu)
class Usuario(db.Model):
    __tablename__ = 'usuario'
    IdUsuario = db.Column(db.Integer, primary_key=True)
    Email = db.Column(db.String(120), unique=True, nullable=False)
    Senha = db.Column(db.String(200), nullable=False)
    NomeUsuario = db.Column(db.String(80), nullable=False)
    EstiloTreino = db.Column(db.Integer)
    DiasAtivos = db.Column(ARRAY(db.String(10)))  # Ex: ['seg', 'ter']

    # Relacionamentos
    treinos = db.relationship('Treino', backref='usuario')
    dias_treino = db.relationship('DiaTreino', backref='usuario')

class Treino(db.Model):
    __tablename__ = 'treino'
    IdTreino = db.Column(db.Integer, primary_key=True)
    NomeTreino = db.Column(db.String(100), nullable=False)
    IdUsuario = db.Column(db.Integer, db.ForeignKey('usuario.IdUsuario'), nullable=False)
    IdExercicios = db.Column(ARRAY(db.Integer))  # Lista de IDs de exercícios
    DiaSemana = db.Column(db.String(10))  # Ex: 'segunda'

    # Relacionamento com DiaTreino
    dias_treino = db.relationship('DiaTreino', backref='treino')

class DiaTreino(db.Model):
    __tablename__ = 'diatreino'
    IdDiaTreino = db.Column(db.Integer, primary_key=True)
    IdTreino = db.Column(db.Integer, db.ForeignKey('treino.IdTreino'), nullable=False)
    IdUsuario = db.Column(db.Integer, db.ForeignKey('usuario.IdUsuario'), nullable=False)
    DataTreino = db.Column(db.Date, nullable=False)

    # Relacionamento com ExercicioTreino
    exercicios = db.relationship('ExercicioTreino', backref='diatreino')

class Exercicio(db.Model):
    __tablename__ = 'exercicio'
    IdExercicio = db.Column(db.Integer, primary_key=True)
    NomeExercicio = db.Column(db.String(100), nullable=False)
    Grupamento = db.Column(db.String(50))  # Ex: 'Peito', 'Costas'

    # Relacionamento com ExercicioTreino
    treinos = db.relationship('ExercicioTreino', backref='exercicio')

class ExercicioTreino(db.Model):
    __tablename__ = 'exerciciotreino'
    IdExercicioTreino = db.Column(db.Integer, primary_key=True)
    IdExercicio = db.Column(db.Integer, db.ForeignKey('exercicio.IdExercicio'), nullable=False)
    IdDiaTreino = db.Column(db.Integer, db.ForeignKey('diatreino.IdDiaTreino'), nullable=False)
    Cargas = db.Column(ARRAY(db.Integer))  # Ex: [50, 55, 60]
    Repeticoes = db.Column(ARRAY(db.Integer))  # Ex: [12, 10, 8]




# Realizando testes para conectar a minha API no meu aplicativo
@app.route('/api/palavra', methods=['GET']) 
def getPalavra():
    return "tijolo"

@app.route('/api/usuario', methods=['POST']) 
def postUsuario():
    # Obter dados do corpo da requisição
    dados = request.get_json()
    
    # Verificar se todos os campos obrigatórios estão presentes
    campos_obrigatorios = ['Email', 'Senha', 'NomeUsuario']
    for campo in campos_obrigatorios:
        if campo not in dados:
            return jsonify({'erro': f'Campo obrigatório ausente: {campo}'}), 400
    
    # Verificar se o email já existe
    usuario_existente = Usuario.query.filter_by(Email=dados['Email']).first()
    if usuario_existente:
        return jsonify({'erro': 'Email já cadastrado'}), 409
    
    # Criar novo usuário
    novo_usuario = Usuario(
        Email=dados['Email'],
        Senha=dados['Senha'],  # Nota: Em produção, é importante hash+salt a senha
        NomeUsuario=dados['NomeUsuario'],
        EstiloTreino=dados.get('EstiloTreino'),  # Campos opcionais usam .get()
        DiasAtivos=dados.get('DiasAtivos', [])
    )
    
    try:
        # Adicionar ao banco e confirmar transação
        db.session.add(novo_usuario)
        db.session.commit()
        
        # Retornar dados do usuário criado (exceto senha)
        return jsonify({
            'sucesso': True,
            'usuario': {
                'IdUsuario': novo_usuario.IdUsuario,
                'Email': novo_usuario.Email,
                'NomeUsuario': novo_usuario.NomeUsuario,
                'EstiloTreino': novo_usuario.EstiloTreino,
                'DiasAtivos': novo_usuario.DiasAtivos
            }
        }), 201
    except Exception as e:
        # Desfazer transação em caso de erro
        db.session.rollback()
        return jsonify({'erro': f'Erro ao cadastrar usuário: {str(e)}'}), 500


@app.route('/api/treino', methods=['POST'])
def registerTraining():
    
    dados = request.get_json()  # Recebe dados via body (mais seguro)

    nomeTreino = dados['nomeTreino']
    idUsuario = dados['idUsuario']
    idExercicios = dados['idExercicios']
    
    if not (dados['diaTreino'] is None):
        diaTreino = dados['diaTreino']
    else:
        diaTreino = None


    try:
        treino = Treino(
            NomeTreino=nomeTreino,
            IdUsuario=idUsuario,
            IdExercicios=idExercicios,
            DiaSemana=diaTreino
        )

        db.session.add(treino)
        db.session.commit()
        
        return jsonify({
            'sucesso': True,
            'treino': {
                'id': treino.IdTreino,
                'nome': treino.NomeTreino,
                'idUsuario': treino.IdUsuario,
                'idExercicios': treino.IdExercicios,
                'diaSemana': treino.DiaSemana
            }
        }), 200  # Código 200 para sucesso
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'erro': f'Erro ao cadastrar usuário: {str(e)}'}), 500

@app.route('/api/treino', methods=['GET'])
def getTrainings():
    IdUsuario = int(request.args.get('idUsuario'))
    print(IdUsuario)
    if not IdUsuario:
        return jsonify({'erro': 'IdUsuario é obrigatório'}), 400

    try:
        treinos = Treino.query.filter_by(IdUsuario=int(IdUsuario)).all()
        for treino in treinos:
            treinosExerciciosTemp = []
            for exercicio in treino.IdExercicios:
                treinosExerciciosTemp.append(Exercicio.query.filter_by(IdExercicio=(exercicio + 1)).first().NomeExercicio)
            treino.IdExercicios = treinosExerciciosTemp

            
        return jsonify([{
            'name': treino.NomeTreino,
            'exercises': treino.IdExercicios,
            'day': treino.DiaSemana
        } for treino in treinos])
    except Exception as e:
        return jsonify({'erro': f'Erro ao buscar treinos: {str(e)}'}), 500

@app.route('/api/login', methods=['POST'])
def getLogin():
    
    dados = request.get_json()  # Recebe dados via body (mais seguro)

    if not dados or 'Email' not in dados or 'Senha' not in dados:
        return jsonify({'erro': 'Credenciais ausentes'}), 400

    email = dados['Email']
    senha = dados['Senha']

    try:
        usuario = Usuario.query.filter_by(Email=email).first()

        if usuario is None:
            return jsonify({'erro': 'Usuário não encontrado'}), 404
        
        if usuario.Senha != senha:
            return jsonify({'erro': 'Senha incorreta'}), 401
        
        return jsonify({
            'sucesso': True,
            'usuario': {
                'id': usuario.IdUsuario,
                'nome': usuario.NomeUsuario,
                'email': usuario.Email,
                'estiloTreino': usuario.EstiloTreino
                # Nunca retorne a senha!
            }
        }), 200  # Código 200 para sucesso
        
    except Exception as e:
        db.session.rollback()
        return jsonify({'erro': f'Erro ao cadastrar usuário: {str(e)}'}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=3000, debug=True)  # Porta 3000