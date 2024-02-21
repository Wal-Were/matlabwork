% Define the function
str_f = input('Enter the function (e.g., "exp(-x) - x"): ', 's');
f = str2func(['@(x)', str_f]);
xl = input('Enter the lower bound (e.g., -2): ');
delta_x = input('Enter the delta x (e.g., 0.01): ');
x = xl:delta_x:2;

method = input('Enter the method to use (1 for Bisection, 2 for Incremental, 3 for Graphical): ');

root = NaN; % Initialize root

if method == 1
    % Bisection Method
    a = xl; 
    b = 2; 
    tol = 1e-6; 
    i = 0; 
    
    A = [];
    B = [];
    DeltaX = [];
    FXL = [];
    FXMU = [];
    FXLFXMU = [];

    while abs(b-a) > tol
        c = (a + b) / 2;
        deltaX = abs(b - a);
        fxL = f(a);
        fxMU = f(c);
        fxlfxmu = fxL * fxMU;
        A = [A; a];
        B = [B; b];
        DeltaX = [DeltaX; deltaX];
        FXL = [FXL; fxL];
        FXMU = [FXMU; fxMU];
        FXLFXMU = [FXLFXMU; fxlfxmu];
        if f(c) == 0
            break;
        elseif f(a)*f(c) < 0
            b = c;
        else
            a = c;
        end
        i = i + 1;
    end

    T = table(A, B, DeltaX, FXL, FXMU, FXLFXMU);
    disp(T);

    root = (a + b) / 2;
    disp(['Root found with Bisection Method: ', num2str(root)]);

elseif method == 2
    % Incremental Method
    if delta_x > 0.01
        disp('Warning: delta x is too large for Incremental Method. Setting delta x to 0.01.');
        delta_x = 0.01;
    end
    [min_val, min_index] = min(abs(f(xl:delta_x:2)));
    root = xl + delta_x * (min_index - 1);
    if isnan(root)
        disp('No root found with Incremental Method');
    else
        disp(['Root found with Incremental Method: ', num2str(root)]);
    end

elseif method == 3
    % Graphical Method
    [min_val, min_index] = min(abs(f(x)));
    root = x(min_index);
    disp(['Estimated root from Graphical Method: ', num2str(root)]);

else
    disp('Invalid method. Please enter 1, 2, or 3.');
end

if ~isnan(root)
    figure;
    plot(x, f(x), 'b', root, f(root), 'ro');
    title('Root Finding Method');
    xlabel('x');
    ylabel('f(x)');
    grid on;
end