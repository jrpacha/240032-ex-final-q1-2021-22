clearvars
close all

vertexs = [
    1, 1;
    7, 1;
    7, 5;
    1, 5;
    1, 1
    ];
plot(vertexs(:,1),vertexs(:,2),...
    '-o',...
    'LineWidth',2,...
    'MarkerFaceColor','black',...
    'MarkerSize',10,...
    'color','black')
axis off

text(0.55,0.75,'$(x_{1}, y_{1})$','Interpreter','LaTeX','FontSize',22)
text(6.55,0.75,'$(x_{2}, y_{1})$','Interpreter','LaTeX','FontSize',22)
text(6.55,5.25,'$(x_{2}, y_{2})$','Interpreter','LaTeX','FontSize',22)
text(0.55,5.25,'$(x_{1}, y_{2})$','Interpreter','LaTeX','FontSize',22)

text(1.15,1.15,'$1$','Interpreter','LaTeX','FontSize',18,'Color','red')
text(6.75,1.15,'$2$','Interpreter','LaTeX','FontSize',18,'Color','red')
text(6.75,4.85,'$3$','Interpreter','LaTeX','FontSize',18,'Color','red')
text(1.15,4.85,'$4$','Interpreter','LaTeX','FontSize',18,'Color','red')

text(4.0,1.15,'$a$','Interpreter','LaTeX','FontSize',30)
text(6.7,3.1,'$b$','Interpreter','LaTeX','FontSize',30)

text(4,3,'$\Omega^{e}$','Interpreter','LaTeX','FontSize',45)

print -dpng 'rectangleElement.png'