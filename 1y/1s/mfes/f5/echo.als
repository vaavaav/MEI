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

}

// O grafo definido pela relação adj é não orientado.
fact NaoOrientado {

}

// O grafo definido pela relação adj é ligado.
fact Ligado {

}

// Inicialmente rcvd, parent e children estão vazias 
// e o initiator envia um Ping para todos os vizinhos

fact init {

}

// Eventos

// Um finish pode ocorrer quando um nó está ready, enviando esse nó 
// uma mensagem do tipo Echo ao seu parent.

pred finish [n : Node] {

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
	// O initiatior nunca tem pai.

	// O pai tem sempre que ser um dos vizinhos.

	// Um nó só pode ser filho do seu pai.

}
check Invariantes

// A propriedade fundamental do protocolo

assert SpanningTree {
	// Quando todos os nós estão ready a relação children forma uma 
	// spanning tree com raiz no initiator.

}
check SpanningTree
