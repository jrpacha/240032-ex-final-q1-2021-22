clearvars
close all

vertexsRectangle = [
    1, 1;
    7, 1;
    7, 5;
    1, 5;
    1, 1
    ];

vertexsTriangle = [
    1, 1;
    7, 1;
    7, 5;
    1, 1
    ];

figure

subplot(1,2,1);

plot(vertexsRectangle(:,1),vertexsRectangle(:,2),...
    '-o',...
    'LineWidth',2,...
    'MarkerFaceColor','black',...
    'MarkerSize',10,...
    'color','black')

axis equal
axis off

text(0.25,0.5,'$(x_{1}, y_{1})$','Interpreter','LaTeX','FontSize',18)
text(6.25,0.5,'$(x_{2}, y_{1})$','Interpreter','LaTeX','FontSize',18)
text(6.25,5.5,'$(x_{2}, y_{2})$','Interpreter','LaTeX','FontSize',18)
text(0.25,5.5,'$(x_{1}, y_{2})$','Interpreter','LaTeX','FontSize',18)

text(1.25,1.25,'$1$','Interpreter','LaTeX','FontSize',14,'Color','red')
text(6.5,1.25,'$2$','Interpreter','LaTeX','FontSize',14,'Color','red')
text(6.5,4.575,'$3$','Interpreter','LaTeX','FontSize',14,'Color','red')
text(1.25,4.575,'$4$','Interpreter','LaTeX','FontSize',14,'Color','red')

text(4.0,1.25,'$a$','Interpreter','LaTeX','FontSize',18)
text(6.6,3.1,'$b$','Interpreter','LaTeX','FontSize',18)

text(3.9,2.5,'$\Omega^{r}$','Interpreter','LaTeX','FontSize',24)

text(1.5,-0.5,...
    'Figure 2. Rectangle element','Interpreter','LaTeX','FontSize',12)


subplot(1,2,2)
plot(vertexsTriangle(:,1),vertexsTriangle(:,2),...
    '-o',...
    'LineWidth',2,...
    'MarkerFaceColor','black',...
    'MarkerSize',10,...
    'color','black')
axis equal
axis off

text(4.6,1.25,'$a$','Interpreter','LaTeX','FontSize',18)
text(6.6,3.1,'$b$','Interpreter','LaTeX','FontSize',18)

text(1.8,1.25,'$1$','Interpreter','LaTeX','FontSize',14,'Color','red')
text(6.5,1.25,'$2$','Interpreter','LaTeX','FontSize',14,'Color','red')
text(6.6,4.4,'$3$','Interpreter','LaTeX','FontSize',14,'Color','red')

text(4.5,2.5,'$\Omega^{t}$','Interpreter','LaTeX','FontSize',24)

text(1.25,-0.5,...
    'Figure 3. Right triangle element','Interpreter','LaTeX','FontSize',12)

print -dpng 'rectangleElement.png'
