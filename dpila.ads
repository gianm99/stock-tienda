generic
   type elem is private;
package dpila is
   type pila is limited private;
   mal_uso: exception;
   espacio_desbordado : exception; --overflow
   procedure pvacia(p: out pila);
   procedure empila(p: in out pila; x: in elem );
   procedure desempila(p: in out pila);
   function cima(p: in pila) return elem ;
   function estavacia( p: in pila) return boolean;
private
   type nodo;
   type pnodo is access nodo;
   type nodo is record
      x: elem;
      sig: pnodo;
   end record;
   type pila is record
      top: pnodo;
   end record;
end dpila;
