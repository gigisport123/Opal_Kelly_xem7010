import matplotlib.pyplot as plt
import numpy as np
import csv

# date: March 3  (Sunday)
# v_p_n = [-100,-50,0,50,100]
# freq_n = [216,380,444,480,502]
# freq_p = [550,466,447,392,244]

# date: March 6 (Wednesday)
v_p_n = [-125, -100, -75, -50, -25, 0, 25, 50, 75, 100, 125]
freq_n = [127, 273, 364, 396, 429, 447, 465, 489, 515, 553, 589]
freq_p = [587, 559, 522, 491, 471, 450, 427, 400, 360, 291, 135]

# data: March 17 (Sunday)
# import from Cadence simulation
fread = './ring_osc_sweep_vinn.csv'
vinn, osc_n_n, osc_p_n = np.loadtxt(
    fread, delimiter=',',skiprows=1, unpack='True'
)    

# change unit from Hz to MHz
osc_n_n = osc_n_n / 10**6
osc_p_n = osc_p_n / 10**6
# reversed order due to x-axis is Vinp - Vinn
osc_p_n = osc_p_n[::-1]
osc_n_n = osc_n_n[::-1]
vinn = (0 - vinn) * 1000
vinn = vinn[::-1]

fread = './ring_osc_sweep_vinp.csv'
vinp, osc_n_p, osc_p_p = np.loadtxt(
    fread, delimiter=',',skiprows=1, unpack='True'
)    

osc_n_p = osc_n_p / 10**6
osc_p_p = osc_p_p / 10**6
vinp = vinp * 1000
freq_n_sim = list(osc_n_n)+list(osc_n_p[1:])
freq_p_sim = list(osc_p_n)+list(osc_p_p[1:])
v_p_n_sim = list(vinn)+list(vinp[1:])

# plot simulation 
plt.plot(v_p_n_sim, freq_n_sim, label = "osc N sim", marker = '*', color='r', linestyle='--')
plt.plot(v_p_n_sim, freq_p_sim, label = "osc P sim", marker = '*', color='g', linestyle='--')

plt.plot(v_p_n, freq_n, label = "osc N", marker = 'o', color='r', linestyle='-')
 
# plotting the line 2 points 
plt.plot(v_p_n, freq_p, label = "osc P", marker = 'o', color='g', linestyle='-')
 
 
# naming the x axis
plt.xlabel('voltage diff (p-n) (mV)')
# naming the y axis
plt.ylabel('freq (MHz)')
# giving a title to my graph
# plt.title('Two lines on same graph!')
 
# show a legend on the plot
plt.legend()
 
# function to show the plot
plt.show()
# plt.savefig('summary_f_vs_v')
