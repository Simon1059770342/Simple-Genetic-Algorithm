% Date��2015��6��1�� 14:01:35
% Author��heartsuit
% Function�������Ŵ��㷨(Simple Genetic Algorithm, SGA)��ʵ��
%          �������һԪ������ĳ�������ڵ���ֵ������ͼ��ӳѰ�Ź��̣�
% Description����д�ó����Ŀ����Ҫ���˽�SGA�Ļ���ԭ���Լ���������
%              ͨ���������С���⣬��ֱ����̵����SGA��
% Instruction������Ҫ����µ����⣬ֻ��������������
%              function evaluateValue = f(x)
%              ���Ŀ�꺯�����ʽ���ɣ�

% GeneticAlgo(encodingBits, left, right)���������
%      encodingBits������λ��������ʵ������ȷ��
%      left:������˵�
%      right:������˵�
% Note��
%      numbleOfSample���������������鷶Χ��20~100
%      maxIteration�����������������鷶Χ��100~500

% ���ڲ��Ե�����������Բ������·�ʽ���ú�����
% Q1: GeneticAlgo(8, -2, 3)
% Q2: GeneticAlgo(22, -1, 2)
function GeneticAlgo(encodingBits, left, right)
% ����Ĭ��ֵ�����ԸĶ���
numbleOfSample = 50;                 % Ĭ��������Ϊ50
maxIteration = 100;                  % Ĭ������������Ϊ100��
mutationProbability = 0.007;         % ������ʣ����鷶Χ��0.001~0.01
iteration = 1;                       % ����������ʼ��
currentIndividual = -1;  
bestIndividual = zeros(maxIteration, 1);           % ���Ա���ÿ���ҵ����������ֵ

% �����Ʊ��루������->�����ͣ�
sample = randi(2, numbleOfSample, encodingBits) - 1;  % ��ʼ����Ⱥ
figure(1);
while (iteration < maxIteration)                   % �Ŵ�����
    % ��������ֵ
    [evaluateValue, evaluateX, evaluateIndividual] = evaluate(sample, left, right, encodingBits);
    if (evaluateIndividual > currentIndividual)
        currentX = evaluateX;                      % ������Ѹ���ĺ�����
        currentIndividual = evaluateIndividual;    % ������Ѹ���
    end;
    bestIndividual(iteration) = currentIndividual; % ���浱ǰ��Ѹ���
    plot(bestIndividual(1:iteration)); grid on; pause(0.1);
    sample = select(sample, evaluateValue);        % ѡ��
    sample = cross(sample, encodingBits);          % ����
    sample = mutate(sample, mutationProbability);  % ����
    iteration = iteration + 1;
end;

% ���
disp(currentIndividual);  disp(iteration);  disp(currentX);

% ���죨����λ���죩
function sampleGenetic = mutate(sample, mutationProbability)
[numbleOfSample, encodingBits] = size(sample);
sampleGenetic = sample;
for kn = 1:numbleOfSample,  
    for km = 1:encodingBits
        r = rand(1);
        if (r < mutationProbability)
            sampleGenetic(kn, km) = double(~ sampleGenetic(kn, km)); 
        end;
    end;
end;

% ���棨���㽻�棩
function sampleGenetic = cross(sample, encodingBits)
numbleOfSample = size(sample, 1);  sampleGenetic = sample;
M2 = floor(numbleOfSample/2);
for k = 1:M2    
    r1 = randi(numbleOfSample, 1); 
    r2 = randi(numbleOfSample, 1);
    Y1 = sample(r1, :);
    Y2 = sample(r2, :);
    % ������ʽ��鷶Χ��0.4~0.9
    r = randi(encodingBits-1, 1);               % ������ɽ���λ��
    Y11 = [Y1(1:r),  Y2((r+1):encodingBits)];
    Y21 = [Y2(1:r),  Y1((r+1):encodingBits)];
    sampleGenetic(r1, :) = Y11;  sampleGenetic(r2, :) = Y21;
end;

% ѡ�����̶ģ�
function sampleGenetic = select(sample, evaluateValue)
numbleOfSample = size(sample, 1); 
evaluateValuer = cumsum(evaluateValue);
sampleGenetic = zeros(size(sample));
for k = 1:numbleOfSample
    r = rand(1);
    I = 1;
    for kr  = 2:numbleOfSample
        if ((r<evaluateValuer(kr)) && (r>=evaluateValuer(kr-1)))
            I = kr;
            break;
        end;
    end;
    sampleGenetic(k, :) = sample(I, :);
end;

% ���� 2->10����, bin2dec()
function [evaluateValue, evaluateX, evaluateIndividual] = evaluate(sample, left, right, encodingBits)
evaluateValue = zeros(size(sample, 1), 1);
evaluateIndividual  =  -1;
evaluateX = left;   % ��ȻevaluateX��Ϊ����ֵ����Ҫ��֤���丳ֵ���˴���ʼ��Ϊ��߽�
for k = 1:size(sample, 1)
    s = num2str(sample(k, :));
    s = strrep(s, ' ', '');     % �ҵ�s�еĿո��滻Ϊ�գ���ɾ���ַ����еĿո�
    x = left + (right-left)/(2^encodingBits-1) * bin2dec(s);        % ���루������->�����ͣ�
    evaluateValue(k) = f(x);
    if (evaluateValue(k) > evaluateIndividual)
        evaluateX = x; 
        evaluateIndividual = evaluateValue(k);
    end;
end;
evaluateValue = evaluateValue/sum(evaluateValue);    %  ��һ��

% ��Ӧ�Ⱥ��������ڴ˴����Ҫ����Ŀ�꺯����
function evaluateValue = f(x)
% Test1��
% %  Q1: f(x) = 10*x/sin(10*x); ��[-2, 3]����Сֵ
% Note������������Ŵ��㷨����Ķ��������ֵ������ȡ���������ĵ���
%       ѧ��������ͬѧ��֪����������ļ���ֵΪ1����x = 0��ȡ��
%       ������ͼ��֤��
% x = -2:.01:3;
% f = sin(10 * x)./(10 * x);
% plot(x, f); grid on;
% evaluateValue = sin(10*x+eps)./(10*x+eps);

% Test2��
% %  Q2: f(x) = x*sin(10*pi*x)+2.0; ��[-1, 2]�����ֵ�������ȷ��6λС����
% Note��
%     �˴���ȻҪ��ȷ��6ΪС����������ʵMATLAB�Ѿ�������15Ϊ˫����
%     ��ͨ��vpa(num, 6)ʵ��

% �鿴f��ͼ�񣬿�֪����[-1, 2]��f�����ֵ��x = 1.85��ȡ�ã�ֵΪ3.85
% x = -1:.01:2;
% f =  x .* sin(10*pi*x) + 2.0;
% plot(x, f); grid on;
evaluateValue = x .* sin(10*pi*x) + 2.0;