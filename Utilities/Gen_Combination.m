clear;clc;
syms x;
syms px;
syms y;
syms py;

zo=[1,1,1,1];
fo=[x,px,y,py];
so=[];
for i=1:4
   so=[so,fo(i)*fo(i:end)];
end

to=[];
for i=1:4
   to=[to,fo(i)*so(i:end),];
end

to=Norep(to);

qo=[];
for i=1:4
   qo=[qo,fo(i)*to(i:end),];
end

qo=Norep(qo);
return;
%% Calcolo combinatorio
%classe:
k=4;
%N° elementi:
n=4;
%Lunghezza vettore aspettata:
l=nchoosek(n+k-1,k);
%%
function[N_vec]=Norep(vec)
    i=1;
    while i<length(vec)
        k=find(vec==vec(i));
        if length(k)>1
            vec(k(2:end))=[];
        end
        i=i+1;
    end
    N_vec=vec;
end

