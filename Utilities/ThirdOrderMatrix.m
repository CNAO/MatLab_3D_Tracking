%% Extrapolation matrix at third order

function[Mlin,M3,K,S,O,X00] = ThirdOrderMatrix(Coordinates,Momentum,t0,tf,N)

XF=zeros(4,N); %local coordinates vector at the end
X0=zeros(4,N); %local coordinates vector at beginning
for i=1:N
        XF(:,i)=[Coordinates{i}(tf,1),Momentum{i}(tf,1),Coordinates{i}(tf,2),Momentum{i}(tf,2)];
        X0(:,i)=[Coordinates{i}(t0,1),Momentum{i}(t0,1),Coordinates{i}(t0,2),Momentum{i}(t0,2)];
end

I0=linspace(1,1,size(X0,2))';
X00=[I0...
    X0'...
    X0.^2'...
    X0(1,:)'.*X0(2:4,:)'...
    X0(2,:)'.*X0(3:4,:)'...
    X0(3,:)'.*X0(4,:)'....
    (X0(1,:).^2)'.*X0'...
    (X0(2,:).^2)'.*X0'...
    (X0(3,:).^2)'.*X0'....
    (X0(4,:).^2)'.*X0'....
    X0(1,:)'.*X0(2,:)'.*X0(3:4,:)' X0(1,:)'.*X0(3,:)'.*X0(4,:)' X0(2,:)'.*X0(3,:)'.*X0(4,:)'
    ];

M3=XF/X00';
K=M3(:,1);
Mlin=M3(:,2:5);
S=M3(:,6:15);
O=M3(:,16:end);
end