# EcosimPro Standard Libraries and Examples

This repository contains a collection of **standard libraries** and **example models** for the EcosimPro / PROOSIS modelling and simulation environment.

The goal of this project is to provide:

* Reusable components organised into libraries
* Didactic examples that show how to build and simulate models
* A starting point for students and engineers learning the EcosimPro language and workflow

> **Note**
> This repository is **not an official EcosimPro / PROOSIS product**.
> It is provided as-is by the author.

---

## Table of Contents

* [Overview](#overview)
* [Repository Structure](#repository-structure)

---

## Overview

EcosimPro / PROOSIS is a modelling and simulation environment used to model 0D/1D multidisciplinary systems described by differential-algebraic equations and discrete events.

This repository focuses on:

* Sharing **standard-style libraries** that can be reused in multiple projects
* Providing **examples** that demonstrate how to use these libraries in practice

---

## Repository Structure

The repository is organised into three main folders:

- `EcosimPro_Languaje/`  
  Material related to the EcosimPro / PROOSIS modelling language: source files, definitions and/or reference code that can be reused when creating new libraries and models.

- `Standard_Libs/`  
  Source code for standard-style libraries (components, ports, functions, etc.).  
  These libraries are intended to be imported into an EcosimPro workspace and used as building blocks in different projects.
  These libraries are:
  - CONTROL: Library for building control systems with signal ports, continuous/discrete blocks, controllers and logic for feedback and sequencing.
  - DEFAULT_LIB: Example library showcasing EL syntax and modelling patterns through ready-to-run demo components and experiments.
  - ELECTRICAL: Components and ports for transient and steady electrical circuits and electromechanical interactions (e.g., sources, switches, power electronics).
  - GRAVITATIONAL: Models for gravitational dynamics and orbital/astrodynamics interactions under central-body gravity and related forces.
  - MATH: Common units, constants and mathematical utilities that standardize units and support numerical modelling across libraries.
  - MECHANICAL: Rotational and translational mechanics library with actuators, sensors, inertias, compliant/rigid couplings and stops.
  - PHYSIOLOGICAL: Components aimed at modelling biological and physiological processes using EL’s continuous/discrete framework.
  - PORTS_LIB: Shared port definitions (analog/bool signals, electrical, thermal, mechanical) to enable consistent interconnection across libraries.
  - THERMAL: Thermal nodes and conductors for conduction, convection and radiation, including variable heat capacity and radiative exchange.
  - TURBOJET: Gas-turbine propulsion library for turbojet engine elements and performance simulation workflows.

- `Standard_Libs_Examples/`  
  A collection of example models and experiments that use the libraries from `Standard_Libs/`.  
  They are useful as:
  - Learning material
  - Regression tests for the libraries
  - Templates for new projects

> The exact contents of each folder (sub-libraries, components, etc.) can be inspected directly in the repository or within EcosimPro once the workspace is configured.

