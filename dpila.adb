package body dpila is

   procedure pvacia(p: out pila) is
      top: pnodo renames p.top;
   begin
      top := null;
   end pvacia;

   function estavacia(p: in pila) return boolean is
      top: pnodo renames p.top;
   begin
      return top=null;
   end estavacia;

   function cima(p: in pila) return elem is
      top: pnodo renames p.top;
   begin
      return top.x;
   exception
      when constraint_error => raise mal_uso;
   end cima;

   procedure empila(p: in out pila; x: in elem) is
      top: pnodo renames p.top;
      r: pnodo;
   begin
      r:= new nodo;
      r.all:= (x, top);
      top:= r;
   exception
      when storage_error => raise espacio_desbordado;
   end empila;

   procedure desempila(p: in out pila) is
      top: pnodo renames p.top;
   begin
      top:= top.sig;
   exception
      when constraint_error => raise mal_uso;
   end desempila;
end dpila;
