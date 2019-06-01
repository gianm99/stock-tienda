package body darbolavl is
   type modo is (insert_mode,remove_mode);

   ----------------------------------------
   -- Procedimientos locales del package --
   ----------------------------------------

   procedure rebalanceo_izq(p: in out pnodo; h: out boolean; m: in modo) is
      -- O p.lc ha crecido en altura un nivel (por insercion) o p.rc ha
      --decrecido un nivel (por borrado)
      a: pnodo; -- el nodo inicialmente en la raiz
      b: pnodo; -- hijo izq de a
      c, b2: pnodo; -- hijo der de b
      c1, c2: pnodo; -- hijos izq y der de c
   begin
      a:= p; b:= a.lc;
      if b.bl<=0 then -- promociona b
         b2:= b.rc; -- asigna nombre
         a.lc:= b2;
         b.rc:=a;
         p:= b; -- reestructura
         if b.bl=0 then -- actualiza bl y h
            a.bl:= -1;
            b.bl:= 1;
            if m=remove_mode then
               h:= false;
            end if ; -- else h se mantiene true
         else -- b.bl= -1
            a.bl:= 0;
            b.bl:= 0;
            if m=insert_mode then h:= false; end if; -- else h se mantiene true
         end if ;
      else -- promociona c
         c:= b.rc; c1:= c.lc; c2:= c.rc; -- asigna nombres
         b.rc:= c1; a.lc:= c2; c.lc:= b; c.rc:= a; p:= c; -- reestructura
         if c.bl<=0 then b.bl:= 0; else b.bl:=-1; end if ; -- actualiza bl y h
         if c.bl>=0 then a.bl:= 0; else a.bl:= 1; end if ;
         c.bl:= 0;
         if m=insert_mode then h:= false; end if ;
      end if ;
   end rebalanceo_izq;

   procedure balanceo_izq(p: in out pnodo; h: in out boolean; m: in modo) is
      --  p.lc ha crecido en altura un nivel (por insercion)
      -- o p.rc ha decrecido un nivel (por borrado)
   begin
      if p.bl=1 then
         p.bl:= 0;
         if m=insert_mode then h:= false; end if ;
      elsif p.bl=0 then --crecio nivel por subarbol izq
         p.bl:= -1;
         if m=remove_mode then h:= false; end if ; -- else h se mantiene a true
      else -- p.bl=-1
         rebalanceo_izq(p, h, m);
      end if ;
   end balanceo_izq;

   procedure rebalanceo_der(p: in out pnodo; h: out boolean; m: in modo) is
      --p.rc ha crecido en altura un nivel (por insercion) o p.lc ha
      -- decrecido un nivel (por borrado)
      a: pnodo; -- el nodo inicialmente en la raiz
      b: pnodo; -- hijo derecho de a
      c, b2: pnodo; -- hijo izq de b
      c1, c2: pnodo; -- hijos der y izq de c
   begin
      a:=p; b:= a.rc;
      if b.bl>=0 then -- promociona b
         b2:= b.lc; -- asigna nombre
         a.rc:= b2;
         b.lc:= a;
         p:= b; -- reestructura
         if b.bl=0 then -- actualiza bl y h
            --COMPROBAR SI ESTO ES CORRECTO
            a.bl:=1;
            b.bl:=-1;
            if m=remove_mode then
               h:=false;
            end if; -- else h se mantiene true
         else -- b.bl=1
            a.bl:=0;
            b.bl:=0;
            if m=insert_mode then h:= false; end if; -- else h se mantiene true
         end if;
      else -- promociona c
         c:= b.lc; c1:= c.rc; c2:= c.lc; -- asigna nombres
         b.lc:= c1; a.rc:= c2; c.rc:= b; c.lc:= a; p:= c; -- reestructura
         if c.bl>=0 then b.bl:=0; else a.bl:= 1; end if; -- actualiza bl y h
         if c.bl<=0 then a.bl:=0; else b.bl:=-1; end if;
         c.bl:=0;
         if m=insert_mode then h:=false; end if;
      end if;
   end rebalanceo_der;

   procedure balanceo_der(p: in out pnodo; h: in out boolean; m: in modo) is
      --p.rc ha crecido en altura un nivel (por insercion)
      --o p.lc ha decrecido un nivel (por borrado)
   begin
      if p.bl=-1 then
         p.bl:=0;
         if m=insert_mode then h:= false; end if;
      elsif p.bl=0 then -- crecio nivel por subarbol der
         p.bl:= 1;
         if m=remove_mode then h:= false; end if;
      else -- p.bl=1
         rebalanceo_der(p, h, m);
      end if;
   end balanceo_der;

   procedure consultar(s: in pnodo; k: in key; x: out item) is
   begin
      if s=null then
         raise no_existe;
      else
         if k<s.k then consultar(s.lc,k,x);
         elsif k>s.k then consultar(s.rc,k,x);
         else x:=s.x;
         end if;
      end if;
   end consultar;

   procedure actualizar(s: in pnodo; k: in key; x: in item) is
   begin
      if s=null then
         raise no_existe;
      else
         if k<s.k then actualizar(s.lc,k,x);
         elsif k>s.k then actualizar(s.rc,k,x);
         else s.x:=x;
         end if;
      end if;
   end actualizar;

   procedure poner(p: in out pnodo; k: in key; x: in item; h: out boolean) is
   begin
      if p=null then
         p:= new nodo;
         p.all:=(k,x,0,null,null);
         h:=true;
      else
         if k<p.k then
            poner(p.lc,k,x,h);
            if h then balanceo_izq(p,h,insert_mode); end if;
         elsif k>p.k then
            poner (p.rc, k, x, h);
            if h then balanceo_der(p, h, insert_mode); end if ;
         else -- k=p.k
            raise ya_existe;
         end if ;
      end if ;
   exception
      when storage_error => raise espacio_desbordado;
   end poner;

   procedure borrado_masbajo(p: in out pnodo; pmasbajo: out pnodo; h: out boolean) is
   begin
      if p.lc/=null then
         borrado_masbajo(p.lc, pmasbajo, h);
         if h then balanceo_der(p, h, remove_mode); end if ;
      else
         pmasbajo:= p; p:= p.rc; h:= true;
      end if ;
   end borrado_masbajo;

   procedure borrado_real(p: in out pnodo; h: out boolean) is
      pmasbajo: pnodo;
   begin
      if p.lc=null and p.rc=null then
         p:=null; h:=true;
      elsif p.lc=null and p.rc/=null then
         p:=p.rc; h:=true;
      elsif p.lc/=null and p.rc=null then
         p:=p.rc; h:=true;
      else
         borrado_masbajo(p.rc,pmasbajo,h);
         pmasbajo.lc:=p.lc; pmasbajo.rc:=p.rc; pmasbajo.bl:=p.bl;
         p:=pmasbajo;
         if h then balanceo_izq(p,h,remove_mode); end if;
      end if;
   end borrado_real;

   procedure borrar(p: in out pnodo; k: in key; h: out boolean) is
   begin
      if p=null then raise no_existe; end if ;
      if k<p.k then
         borrar(p.lc, k, h);
         if h then balanceo_der(p, h, remove_mode); end if ;
      elsif k>p.k then
         borrar(p.rc, k, h);
         if h then balanceo_izq(p, h, remove_mode); end if ;
      else -- k=p.k
         borrado_real(p, h);
      end if ;
   end borrar;

   --------------------------------
   -- Procedimientos del package --
   --------------------------------

   --Vaciar el arbol
   procedure cvacio(s: out arbolavl) is
      raiz: pnodo renames s.raiz;
   begin
      raiz:=null;
   end cvacio;

   --consultar el contenido de un nodo
   procedure consultar(s: in arbolavl; k: in key; x: out item) is
      raiz: pnodo renames s.raiz;
   begin
      consultar(raiz,k,x);
   end consultar;

   --actualizar el contenido de un nodo
   procedure actualizar(s: in arbolavl; k: in key; x: in item) is
      raiz: pnodo renames s.raiz;
   begin
      actualizar(raiz,k,x);
   end actualizar;

   --introducir un nodo nuevo al arbol
   procedure poner(s: in out arbolavl; k: in key; x: in item) is
      raiz: pnodo renames s.raiz;
      h: boolean; --h dice si ha crecido el nivel por una insercion
   begin
      poner(raiz,k,x,h);
   end poner;

   --borrar un nodo del arbol
   procedure borrar(s: in out arbolavl; k: in key) is
      raiz: pnodo renames s.raiz;
      h: boolean;
   begin
      borrar(raiz,k,h);
   end borrar;

   --------------
   -- Iterador --
   --------------

   procedure first(s: in arbolavl; it: out iterador) is
      raiz: pnodo renames s.raiz;
      st: pila renames it.st;
      p: pnodo;
   begin
      pvacia(st); --vaciamos la pila
      if raiz/=null then
         p:=raiz;
         while p.lc/=null loop --buscamos el hijo m�s a la izquierda
            empila(st,p);
            p:=p.lc;
         end loop;
         empila(st,p);
      end if;
   end first;

   procedure next(s: in arbolavl; it: in out iterador) is
      st: pila renames it.st;
      p: pnodo;
   begin
      p:= cima(st);
      desempila(st);
      if p.rc/=null then -- si el nodo tiene hijo derecho
         p:=p.rc;
         while p.lc/= null loop
            empila(st,p);
            p:=p.lc; -- nodo actual, el nodo izquierdo
         end loop;
         empila(st,p);
      end if;
   exception
      when dnodopila.mal_uso => raise darbolavl.mal_uso;
   end next;

   function is_valid(it: in iterador) return boolean is
      st: pila renames it.st;
   begin
      return not estavacia(st);
   end is_valid;

   procedure get(s: in arbolavl; it: in iterador; k: out key; x: out item) is
      st: pila renames it.st;
      p: pnodo;
   begin
      p:=cima(st);
      k:=p.k;
      x:=p.x;
   exception
      when dnodopila.mal_uso => raise darbolavl.mal_uso;
   end get;

   -- recorrido inorden
   procedure inorden(s: in arbolavl) is
      k: key;
      x: item;
      it: iterador;
   begin
      first(s,it);
      while is_valid(it) loop
         get(s, it, k, x);
         print(x);
         next(s,it);
      end loop;
   end inorden;
end darbolavl;
