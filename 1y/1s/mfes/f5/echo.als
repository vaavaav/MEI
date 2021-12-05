// Complete o seguinte modelo de um protocolo
// distribuído para formar uma spanning tree numa rede

sig Node {
	adj : set Node,				// Conjunto de nós vizinhos
	var rcvd : set Node,		// Nós dos quais já processou mensagens
	var parent : lone Node,		// O eventual pai do nó na spanning tree
	var children : set Node,	// Os eventuais filhos do nó na spanning tree
	var inbox : set Message		// Mensagens na inbox (nunca são apagadas)
}
one sig initiator extends Node {}	// O nó que inicia o protocolo

// Tipos de mensagens
abstract sig Type {}
one sig Ping, Echo extends Type {}

// Mensagens enviadas
sig Message {
	from : one Node,		// Nó que enviou a mensagem
	type : one Type			// Tipo da mensagem
}

// Um nó considera-se ready quando já leu e processou mensagens de todos os seus vizinhos. 
// A execução do protocolo termina quando todos os nós estão ready.
fun ready : set Node {
	{ n : Node | n.adj in n.rcvd }
}

// Configuração da rede

// O grafo definido pela relação adj não tem lacetes.
fact SemLacetes {
	no iden & adj
}

// O grafo definido pela relação adj é não orientado.
fact NaoOrientado {
	adj = iden.~adj
}

// O grafo definido pela relação adj é ligado.
fact Ligado {
	Node->Node = ^adj
}

// Inicialmente rcvd, parent e children estão vazias 
// e o initiator envia um Ping para todos os vizinhos

fact init {
	no rcvd
	no parent
	no children
	inbox.Message = initiator.adj
	initiator.adj.inbox.from  = initiator
	initiator.adj.inbox.type  = Ping
}

// Eventos

// Um finish pode ocorrer quando um nó está ready, enviando esse nó 
// uma mensagem do tipo Echo ao seu parent.

pred finish [n : Node] {
	// guard
	// o nó tem de estar ready
	n in ready

	// effect
	one m : n.parent.inbox' | m.type = Echo and m.from = n 

	// frame
	(Node - n.parent) <: inbox' = (Node - n.parent) <: inbox
	rcvd' = rcvd
	parent' = parent
	children' = children

}

// Um read pode ocorrer quando um nó tem uma mensagem 
// ainda não processada na sua inbox. Se o nó não é o initiator
// e é a primeira mensagem que processa (necessariamente um Ping) 
// então o nó que enviou a mensagem passa a ser o seu parent
// na spanning tree e é enviado um Ping a todos os 
// restantes vizinhos (todos menos o novo parent). 
// Se a mensagem recebida é um Echo então o nó que enviou 
// a mensagem é adicionado ao conjunto dos seus children na spanning tree.

pred read [n : Node] {
	// guard
	// o nó tem uma mensagem não processada na sua inbox
	one n.inbox.from - n.rcvd

	// effect
	(n.inbox.from - n.rcvd) != initiator and no n.rcvd implies (
		n.parent' = (n.inbox.from - n.rcvd) and 
		all nd : (n.adj - n.parent') | one m : nd.inbox' | m.type = Ping and m.from = n
	) else parent' = parent and (n.adj - n.parent').inbox' = (n.adj - n.parent').inbox and ( 
			(n.inbox & from.(n.inbox.from - n.rcvd)).type = Echo implies (
			 	 n.children' = n.children + (n.inbox.from - n.rcvd)	
			) else n.children' = n.children )

	rcvd' = rcvd + n->(n.inbox.from - n.rcvd)

	// frame
	(Node - n) <: parent' = (Node - n) <: parent
	(Node - n) <: children' = (Node - n) <: children
	(Node - (n.adj - n.parent')) <: inbox' = (Node - (n.adj - n.parent')) <: inbox
}

pred stutter {
	rcvd' = rcvd
	parent' = parent
	children' = children
	inbox' = inbox
}

fact transitions {
	always (stutter or some n : Node | read[n] or finish[n])
}

// Alguns invariantes do protocolo

assert Invariantes {
	// O initiator nunca tem pai.
	always no initiator.parent
	// O pai tem sempre que ser um dos vizinhos.
	always parent in adj
	// Um nó só pode ser filho do seu pai.
	always children in ~parent
}
check Invariantes

// A propriedade fundamental do protocolo

assert SpanningTree {
	// Quando todos os nós estão ready a relação children forma uma 
	// spanning tree com raiz no initiator.
	eventually (Node = ready implies initiator.^children = (Node - initiator))
}
check SpanningTree
