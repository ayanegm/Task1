import torch 
import torch.nn as nn
from torch.optim import SGD
import matplotlib.pyplot as plt

x = [[1,2], [3,4], [5,6], [7,8]] # hours of studying and test's result
y = [[3], [7], [11], [15]] #final exam result

X = torch.tensor(x).float()
Y = torch.tensor(y).float()

device = 'cuda' if torch.cuda.is_available() else 'cpu'

X = X.to(device)
Y = Y.to(device)

class MyNeuralNet(nn.Module):
    def __init__(self):
        super().__init__()
        self.input_to_hidden_layer = nn.Linear(2,8) # take 2 input paramters from the user and make 8 hidden layers(weights and biases)
        self.hidden_layer_activation = nn.ReLU() #use ReLU activation that max(0,input value)
        self.hidden_to_output_layer = nn.Linear(8,1) #take the 8 output numbers from hte hidden layer and combine them into 1 output number

    def forward(self, x):
        x = self.input_to_hidden_layer(x) #turn 2 input numbers into 8 numbers
        x = self.hidden_layer_activation(x) # passes those 8 numbers through ReLU
        x = self.hidden_to_output_layer(x) # turn those 8 numbers into 1 predicted output number
        return x
    
# this is used for remaining the weight the same every iteration
# torch.manual_seed(0)

mynet = MyNeuralNet().to(device) #create neural network with random weights/biases and move it to device

print("input_to_hidden_layer.weight: " , mynet.input_to_hidden_layer.weight) #printg weight matrix of teh first layer

for par in mynet.parameters():
    print(par)

loss_func = nn.MSELoss() #create MSE that measures how far the prediction from it's true value

_Y = mynet(X)
loss_value = loss_func(_Y, Y) #compute the initial predictions with the true target
print(loss_value)

opt = SGD(mynet.parameters(), lr = 0.001) #stochastic gradient decent that takes the weights and biases that it will update and takes  the learning rate

loss_history = []
for _ in range(50):
    opt.zero_grad() #clears old gradients from previous step , adds new gradients on top of old ones instad on replacing them
    loss_value = loss_func(mynet(X), Y) # count the loss again
    loss_value.backward() # run the backword propagation ,calculate weight and bias showing how increaing or decreasing tehy affect loss 
    opt.step() #  update the bias and weight and accoring to the learnign rate
    loss_history.append(loss_value.item()) #extract number loss number 

plt.plot(loss_history)
plt.title('Loss variation over increasing epochs')
plt.xlabel('epochs')
plt.ylabel('loss value')
plt.show()
