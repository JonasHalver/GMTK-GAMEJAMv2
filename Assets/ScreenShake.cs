using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ScreenShake : MonoBehaviour
{
    public bool shake;
    public Vector2 minShake, maxShake;
    [Range(1, 5)]
    public float shakeSpeed;
    [Range(0,1)]
    public float shakeAmount;

    float t = 0;

    // Start is called before the first frame update
    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        if (shake)
        {
            Shake();
        }
    }

    public void Shake()
    {
        float maxY = Mathf.Lerp(minShake.y, maxShake.y, shakeAmount);
        float maxX = Mathf.Lerp(minShake.x, maxShake.x, shakeAmount);
    }
}
