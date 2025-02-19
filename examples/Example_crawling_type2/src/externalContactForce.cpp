#include "externalContactForce.h"

externalContactForce::externalContactForce(elasticPlate &m_plate, timeStepper &m_stepper, 
        double m_stiffness, double m_dBar, double m_mu, double m_epsilonV)
{
	plate = &m_plate;
	stepper = &m_stepper;

    stiffness = m_stiffness;
    dBar = m_dBar;

    mu = m_mu;

    epsilonV = m_epsilonV;

    dt = plate->dt;

    ForceVec = VectorXd::Zero(plate->ndof);

    Id3<<1,0,
         0,1;

    IdG<<1,0,
    	 0,0;

    mu1 = 0.6;
    mu2 = 0.3;
}

externalContactForce::~externalContactForce()
{
	;
}

void externalContactForce::computeFc()
{
	//ifContact = 0;

	//ForceVec = VectorXd::Zero(plate->ndof);

	for(int i = 0; i < plate->nv; i++)
	{
		Vector3d xCurrent = plate->getVertex(i);

		double d = xCurrent(1);

		if (d <= dBar)
		{
			//cout << "height :" << d << endl;

			dEnergydD = - 2 * (d - dBar) * log(d / dBar) - (d - dBar) * (d - dBar) / d;

			stepper->addForce(3 * i + 1, stiffness * dEnergydD);

			//ifContact = 2;
		}

		
		xCurrent = plate->getVertexOld(i);

		d = xCurrent(1);

		if (d <= dBar)
		{
			dEnergydD = - 2 * (d - dBar) * log(d / dBar) - (d - dBar) * (d - dBar) / d;

			Vector3d uCurrent0 = plate->getVelocityOld(i);

			Vector2d uCurrent;
			uCurrent(0) = uCurrent0(0);
			uCurrent(1) = uCurrent0(1);

			Vector2d vTangent;

			vTangent(0) = uCurrent(0);
			vTangent(1) = 0.0;
			//vTangent(2) = 0.0;

			if ( vTangent.norm() >= epsilonV )
			{
				fVelocity = 1.0;
				tK = vTangent / vTangent.norm();
			}
			else
			{
				fVelocity = - ( vTangent.norm() * vTangent.norm() ) / (epsilonV * epsilonV) + 2 * vTangent.norm() / epsilonV;
				tK = vTangent / (vTangent.norm() + 1e-15);
			}

			if (uCurrent(0) > 0.0)
			{
				mu = mu2;
			}
			else
			{
				mu = mu1;
			}

			friction = - mu * abs(stiffness * dEnergydD) * fVelocity * tK;

			for (int kk = 0; kk < 2; kk++)
			{
				stepper->addForce(3 * i + kk, - friction(kk));
			}
		}

	}

	//stepper->subtractForceVector(-ForceVec);
}

void externalContactForce::computeJc()
{
	for(int i = 0; i < plate->nv; i++)
	{
		Vector3d xCurrent = plate->getVertex(i);

		double d = xCurrent(1);

		if (d <= dBar)
		{
			d2EnergydD2 = - 2 * log(d / dBar) - 2 * (d - dBar) / d - 2 * (d - dBar) / d + (d - dBar) * (d - dBar) / (d * d);

			stepper->addJacobian(3 * i + 1, 3 * i + 1, stiffness * d2EnergydD2);
		}
	}
}
