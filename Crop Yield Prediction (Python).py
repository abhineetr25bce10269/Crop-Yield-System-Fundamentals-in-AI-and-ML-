#       CROP YIELD PREDICTION SYSTEM

# - You enter your predicted field conditions → get a predicted yield.
#   
#   Then enter actual conditions → see how close you were.




import matplotlib.pyplot as plt


# Each column: [rainfall, temp, humidity, fertilizer, soil_ph, sunlight, irrigation, yield]
# Each row represents one past season's field conditions + final yield.
data = [
    [1000, 41, 60, 58, 8.5, 10.4, 9, 4.2],
    [2200, 38, 65, 45, 7.2, 9.8, 8, 5.8],
    [4000, 35, 85, 38, 6.2, 8.4, 4, 8.9],
    [5000, 29, 90, 30, 6.5, 7.6, 2, 9.5],
    [2800, 38, 75, 49, 7.0, 9, 7, 6.0]
]

# Finding sample weights 
# weight = average(yield / feature)
# Here weightis calculated because we want to know how much yield does one unit contribute

weights = [0]*7  # 7 input factors are there

for i in range(7):     # this indicates that the loop runs 7 times
    total = 0
    for row in data:
        if row[i] != 0:
            total += row[7] / row[i]
    weights[i] = total / len(data)   # taking average, so values are more correct

# Entering the input values that we predicted as the result of yield 

# same formula applied to user input values
# For all the values their corresponding units are mentioned

print("Enter the following values for prediction:\n")

rainfall = float(input("Rainfall (mm): "))
temperature = float(input("Temperature (C): "))
humidity = float(input("Humidity (%): "))
fertilizer = float(input("Fertilizer (kg/ha): "))
soil_ph = float(input("Soil pH: "))
sunlight = float(input("Sunlight (hrs): "))
irrigation = float(input("Irrigation level (0-10): "))

#            PREDICTION LOGIC 

# putting all predicted inputs together
# putting all the predicted values in one list instead of handling separately

pred_inputs = [rainfall, temperature, humidity, fertilizer, soil_ph, sunlight, irrigation]

predicted_yield = 0 # its use is that we need a variable to store the final result

# simple loop calculation
# runs 7 times
# here it multiply  each one with its weight and add everything at last
for i in range(len(pred_inputs)):
    predicted_yield += pred_inputs[i] * weights[i]

predicted_yield = round(predicted_yield / 10, 2) # here it is used to decrease the value otherwise it become too large

# shows the final predicted output to the user.

print("\nPredicted Crop Yield (tons/ha): ", predicted_yield)

# Entering the input values that we got in the time of yield (that is actual value)

print("\nNow enter ACTUAL field conditions:\n")

rainfall_a = float(input("Actual Rainfall (mm): "))
temperature_a = float(input("Actual Temperature (C): "))
humidity_a = float(input("Actual Humidity (%): "))
fertilizer_a = float(input("Actual Fertilizer (kg/ha): "))
soil_ph_a = float(input("Actual Soil pH: "))
sunlight_a = float(input("Actual Sunlight (hrs): "))
irrigation_a = float(input("Actual Irrigation level (0-10): "))

#  putting all actual inputs together
#  for easier putting everything in one list. More easier than handling seperate variables

act_inputs = [rainfall_a, temperature_a, humidity_a, fertilizer_a, soil_ph_a, sunlight_a, irrigation_a]

actual_yield = 0  # here it starts from zero and then adding values to it.

# the loops runs 7 times because of 7 inputs

for i in range(len(act_inputs)):
    actual_yield += act_inputs[i] * weights[i]   # multiply each factors with its corresponding weights

actual_yield = round(actual_yield / 10, 2) # keeping only 2 decimal places

print("\nActual Crop Yield (tons/ha): ", actual_yield) #it prints the final result


#           DIFFERENCE IN CALCULATION

#   Just to see difference between predicted and actual value.

difference = actual_yield - predicted_yield  #  to check accuracy roughly

print("\nDifference (Actual - Predicted): ", round(difference, 2))

#               GRAPH SECTION       

# plotting the graph for better understanding
# changed from bar chart to line graph with markers
# the graph shows both the predicted and actual yield values
# the graph heading will be Actual vs Predicted crop yield 

labels = ["Predicted Yield", "Actual Yield"]
values = [predicted_yield, actual_yield]

plt.figure()

# line graph with markers instead of bar chart
plt.plot(labels, values, marker='o', color='green', linewidth=2, markersize=10, markerfacecolor='darkgreen')

# adding value labels on each point
for i, v in enumerate(values):
    plt.text(i, v + 0.1, str(v), ha='center', fontweight='bold')

plt.title("Actual vs Predicted Crop Yield")
plt.xlabel("Type")
plt.ylabel("Yield (tons/ha)")

plt.text(0.5, max(values) * 0.9,
         "Difference = " + str(round(difference, 2)),
         ha='center')

plt.show()