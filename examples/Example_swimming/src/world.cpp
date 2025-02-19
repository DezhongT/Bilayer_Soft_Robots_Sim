#include "world.h"

world::world()
{
	;
}

world::world(setInput &m_inputData)
{
	render = m_inputData.GetBoolOpt("render");				
	saveData = m_inputData.GetBoolOpt("saveData");			
	deltaTime = m_inputData.GetScalarOpt("deltaTime");     
	totalTime = m_inputData.GetScalarOpt("totalTime");    
	YoungM = m_inputData.GetScalarOpt("YoungM");
	density = m_inputData.GetScalarOpt("density");
	rodRadius = m_inputData.GetScalarOpt("rodRadius");
	Possion = m_inputData.GetScalarOpt("Possion");
	stol = m_inputData.GetScalarOpt("stol");
	forceTol = m_inputData.GetScalarOpt("forceTol");
	scaleRendering = m_inputData.GetScalarOpt("scaleRendering");
	maxIter = m_inputData.GetIntOpt("maxIter");
	gVector = m_inputData.GetVecOpt("gVector");
	viscosity = m_inputData.GetScalarOpt("viscosity");

	boxSize = m_inputData.GetScalarOpt("boxSize");
	stiffness = m_inputData.GetScalarOpt("stiffness");
	dBar = m_inputData.GetScalarOpt("dBar");

	indexArray = VectorXi::Zero(9);
	indexArray(0) = 0;
	indexArray(1) = 1;
	indexArray(2) = 21;
	indexArray(3) = 41;
	indexArray(4) = 61;
	indexArray(5) = 81;
	indexArray(6) = 101;
	indexArray(7) = 121;
	indexArray(8) = 141;
}

world::~world()
{
	;
}

bool world::isRender()
{
	return render;
}

void world::OpenFile(ofstream &outfile)
{
	if (saveData==false) return;
	
	int systemRet = system("mkdir datafiles"); //make the directory
	if(systemRet == -1)
	{
		cout << "Error in creating directory\n";
	}

	// Open an input file named after the current time
	ostringstream name;
	name.precision(6);
	name << fixed;

    name << "datafiles/simDER";
    name << ".txt";

	outfile.open(name.str().c_str());
	outfile.precision(10);	
}

void world::CloseFile(ofstream &outfile)
{
	if (saveData==false) 
	{
		return;
	}
}

void world::CoutData(ofstream &outfile)
{
	if (saveData==false) 
	{
		return;
	}

	if ( timeStep % 10 != 0)
	{
		return;
	}

	//if (timeStep == Nstep)
	{
		for (int i = 0; i < plate->nv; i++)
		{
			Vector3d xCurrent = plate->getVertex(i);

			outfile << currentTime << " " << xCurrent(0) << " " << xCurrent(1) << " " << xCurrent(2) << endl;
		}
	}
}

void world::setPlateStepper()
{
	// Create the plate 
	plate = new elasticPlate(YoungM, density, rodRadius, Possion, deltaTime);

	plateBoundaryCondition();

	plate->setup();

	stepper = new timeStepper(*plate);

	// set up force
	m_inertialForce = new inertialForce(*plate, *stepper);
	m_gravityForce = new externalGravityForce(*plate, *stepper, gVector);
	m_dampingForce = new dampingForce(*plate, *stepper, viscosity);
	m_stretchForce = new elasticStretchingForce(*plate, *stepper);
	m_bendingForce = new elasticBendingForce(*plate, *stepper);
	m_twistingForce = new elasticTwistingForce(*plate, *stepper);
	m_elasticStretchingBound = new elasticStretchingBound(*plate, *stepper);
	m_elasticBendingBound = new elasticBendingBound(*plate, *stepper);
	m_elasticTwistingBound = new elasticTwistingBound(*plate, *stepper);
	m_elasticAngleBound = new elasticAngleBound(*plate, *stepper);
	//m_externalContactForceBody = new externalContactForceBody(*plate, *stepper, boxSize, stiffness, dBar);
	
	plate->updateTimeStep();

	// set up first jacobian
	m_inertialForce->setFirstJacobian();
	m_stretchForce->setFirstJacobian();
	m_bendingForce->setFirstJacobian();
	m_twistingForce->setFirstJacobian();
	m_dampingForce->setFirstJacobian();
	m_elasticStretchingBound->setFirstJacobian();
	m_elasticBendingBound->setFirstJacobian();
	m_elasticTwistingBound->setFirstJacobian();
	m_elasticAngleBound->setFirstJacobian();
	//m_externalContactForceBody->setFirstJacobian();

	stepper->first_time_PARDISO_setup();

	// time step 
	Nstep = totalTime / deltaTime;
	timeStep = 0;
	currentTime = 0.0;
}

void world::plateBoundaryCondition()
{

	for (int i = 0; i < 9; i++)
	{
		Vector3d xCurrent = plate->getVertex(indexArray(i));
		plate->setOneVertexBoundaryCondition(xCurrent(0), indexArray(i), 0);
		plate->setOneVertexBoundaryCondition(xCurrent(1), indexArray(i), 1);
	}
}

void world::updateTimeStep()
{
	bool goodSolved = false;

	while (goodSolved == false)
	{
		// Start with a trial solution for our solution x
		plate->updateGuess(); // x = x0 + u * dt

		updateEachStep();

		goodSolved = true;
	}

	plate->updateTimeStep();

	if (render) 
	{
		cout << "time: " << currentTime << " ";
	}

	currentTime += deltaTime;
		
	timeStep++;
}

void world::updateEachStep()
{
	actuationTime = currentTime;

	while ( actuationTime > 0.2)
	{
		actuationTime = actuationTime - 0.2;
	}

	cout << actuationTime << endl;

	if (actuationTime < 0.01)
	{
		for (int i = 160; i < 296; i++)
		{
			//if ( plate->v_edgeElement[i].refLength < 1.1 * plate->v_edgeElement[i].refLength0 )
			{
				plate->v_edgeElement[i].refLength = plate->v_edgeElement[i].refLength + 0.05 * deltaTime;
			}
		}
	}

	if (actuationTime > 0.01)
	{
		for (int i = 160; i < 296; i++)
		{
			if ( plate->v_edgeElement[i].refLength > plate->v_edgeElement[i].refLength0 )
			{
				plate->v_edgeElement[i].refLength = plate->v_edgeElement[i].refLength - 0.05 * deltaTime/18.9;
			}
		}
	}


	double normf = forceTol * 10.0;
	double normf0 = 0;
	
	bool solved = false;
	
	int iter = 0;
		
	while (solved == false)
	{
		plate->prepareForIteration();

		stepper->setZero();

		m_inertialForce->computeFi();
		m_gravityForce->computeFg();
		m_stretchForce->computeFs();
		m_bendingForce->computeFb();
		m_twistingForce->computeFt();
		m_dampingForce->computeFd();

		//m_externalContactForceBody->computeFc();

		m_elasticStretchingBound->computeFs();
		m_elasticBendingBound->computeFb();
		m_elasticTwistingBound->computeFt();
		m_elasticAngleBound->computeFa();
		
		normf = stepper->GlobalForceVec.norm();

		if (iter == 0) 
		{
			normf0 = normf;
		}
		
		if (normf <= forceTol)
		{
			solved = true;
		}
		else if(iter > 0 && normf <= normf0 * stol)
		{
			solved = true;
		}

		normf = 0.0;
		
		if (solved == false)
		{
			m_inertialForce->computeJi();
			m_gravityForce->computeJg();
			m_stretchForce->computeJs();
			m_bendingForce->computeJb();
			m_twistingForce->computeJt();
			m_dampingForce->computeJd();

			//m_externalContactForceBody->computeJc();

			m_elasticStretchingBound->computeJs();
			m_elasticBendingBound->computeJb();
			m_elasticTwistingBound->computeJt();
			m_elasticAngleBound->computeJa();

			stepper->integrator(); // Solve equations of motion
			plate->updateNewtonMethod(stepper->GlobalMotionVec); // new q = old q + Delta q
			iter++;
		}

		if (iter > maxIter)
		{
			cout << "Error. Could not converge. Exiting.\n";
			break;
		}
	}

	if (render)
	{
		cout << "iter " << iter << endl;
	}
}

int world::simulationRunning()
{
	if (timeStep < Nstep) 
	{
		return 1;
	}
	else 
	{
		return -1;
	}
}

Vector3d world::getScaledCoordinate(int i, int j)
{
	Vector3d xCurrent;
	
	if (j == 0)
	{
		xCurrent = plate->v_edgeElement[i].x_1 * scaleRendering;
	}
	if (j == 1)
	{
		xCurrent = plate->v_edgeElement[i].x_2 * scaleRendering;
	}

	return xCurrent;
}

int world::numStretchingPair()
{
	return plate->edgeNum;
}

int world::numBendingPair()
{
	return plate->v_bendingElement.size();
}

Vector3d world::getBoundaryCoordination_left(int i, int j)
{
	Vector3d xCurrent;

	if (j == 0)
	{
		xCurrent = (plate->v_bendingElement[i].x_1 - 0.01 * plate->v_bendingElement[i].m_11) * scaleRendering;
	}
	if (j == 1)
	{
		xCurrent = (plate->v_bendingElement[i].x_3 - 0.01 * plate->v_bendingElement[i].m_21) * scaleRendering;
	}

	return xCurrent;
	
}

Vector3d world::getBoundaryCoordination_right(int i, int j)
{
	Vector3d xCurrent;

	if (j == 0)
	{
		xCurrent = (plate->v_bendingElement[i].x_1 + 0.01 * plate->v_bendingElement[i].m_11) * scaleRendering;
	}
	if (j == 1)
	{
		xCurrent = (plate->v_bendingElement[i].x_3 + 0.01 * plate->v_bendingElement[i].m_21) * scaleRendering;
	}

	return xCurrent;
}

Vector3d world::getScaledCoordinatePoint()
{
	return plate->getVertex(plate->nv - 1) * scaleRendering;
}

double world::getBoxSize()
{
	return boxSize * scaleRendering;
}