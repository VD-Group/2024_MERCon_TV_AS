# Implementation of Fuzzy-based Yaw Stability Control System with Torque Vectoring and Active Steering (MERCon 2024)
This repository contains the implementation codes for our paper titled "Fuzzy-based Yaw Stability Control System with Torque Vectoring and Active Steering", which won the award for the Best Paper (Mechanical Engineering Systems) at Moratuwa Engineering Research Conference, 2024. 


## Table of Contents

- [Introduction](#introduction)
- [Repository Structure](#repository-structure)
- [Installation](#installation)
- [Usage](#usage)
- [Citation](#citation)
- [Acknowledgements](#acknowledgements)

## Introduction
___
<p align="center">
    <img src="Intro.svg" width="500"> <br>
</p>

[//]: # (### Abstract)

>Yaw stability control is essential for the safe operation of a vehicle. This paper presents a __robust fuzzy-based integration__ of __active steering__ with __torque vectoring__ in order to achieve __vehicle yaw stability__. A single-track vehicle model is used to mathematically model the vehicle, accommodating the active front steering and torque vectoring systems. A fuzzy logic controller is employed to calculate the required corrective steering and differential torque based on the error in yaw rate. The implementation of this system is carried out using MATLAB, using the parameters of a compact SUV. Furthermore, an analysis of the effect of the proportion of corrective assistance given by active front steering and torque vectoring is done. The results indicate enhanced vehicle manoeuvrability during cornering, as evidenced by the near alignment of the measured yaw rate with the desired values. The simulations are carried out for two speeds, and in both cases, the effect of the controller is significant, with the __normalised root mean square error__ __reducing from 10% to 3.94% and from 12.9% to 4.01% for 60 km/h and 100 km/h__ respectively. The results also show that __corrective active steering__ has a __greater effect on yaw stability__ than an equivalent amount of corrective torque vectoring.

## Repository Structure

```bash
├── src/                    # Source code
│   ├── scripts/            # Scripts to run experiments
├── README.md               # This README file
├── Results                # Directory for storing results
```

## Installation

To run the code in this repository, you'll need to have [MATLAB 2022](https://in.mathworks.com/products/new_products/release2022a.html?requestedDomain=) installed.

## Usage

The main scripts to run our experiments can be found in the `src/` directory. The results can be reproduced by running the script `Yaw_stability_with_AFS_TV.m`.

## Citation

If you find this code useful in your research, please cite our paper:

```bibtex
@inproceedings{herath2024a,
  author={Herath, Prabhathiya and Rajasuriya, Hiran and Dasanayake, Nimantha and Perera, Shehara and Subasinghe, LU and Gamage, JR},
  booktitle={2024 Moratuwa Engineering Research Conference (MERCon)}, 
  title={Fuzzy-based Yaw Stability Control System with Torque Vectoring and Active Steering}, 
  year={2024},
  volume={},
  number={},
  pages={xxx-xxx},
  keywords={Yaw stability control; Active steering; Torque vectoring; Vehicle dynamics; Fuzzy logic controller},
  doi={TBA}
```

## Acknowledgements

We would like to thank Falcon E Racing, the electric formula student team of the University of Moratuwa for their support.
